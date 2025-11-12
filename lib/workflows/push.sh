#!/usr/bin/env bash
# lib/workflows/push.sh - Workflow composition for pushing changes

set -euo pipefail

# Source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../core/paths.sh"
source "$SCRIPT_DIR/../core/config.sh"
source "$SCRIPT_DIR/../core/git.sh"
source "$SCRIPT_DIR/../core/files.sh"

# push_workflow - Complete workflow for pushing local changes to repository
# input: "push local dotfiles to repository: validate, copy, commit, push"
# Args: $1 - repo root path, $2 - dry run flag (true/false)
# Returns: 0 on success, 1 on failure
push_workflow() {
    local repo_root="$1"
    local dry_run="${2:-false}"

    # Step 1: Validate we're in a git repo
    cd "$repo_root" || return 1
    if ! is_git_repo; then
        echo "Error: Not a git repository: $repo_root" >&2
        return 1
    fi

    # Step 2: Get config values
    local dotfiles_dir branch remote
    dotfiles_dir=$(get_dotfiles_dir) || return 1
    branch=$(get_repo_branch) || return 1
    remote="origin"

    local dotfiles_path="$repo_root/$dotfiles_dir"

    # Step 3: Fetch from remote
    echo "Fetching from remote..."
    if ! fetch_remote "$remote"; then
        echo "Warning: Failed to fetch from remote" >&2
    fi

    # Step 4: Check if we need to pull first
    if is_behind_remote "$remote" "$branch" 2>/dev/null; then
        local behind_count
        behind_count=$(get_commit_count_behind "$remote" "$branch")
        echo "Local branch is $behind_count commit(s) behind remote"
        echo "Pull changes first with: dotdex pull"
        return 1
    fi

    # Step 5: Get tracked files
    local files
    files=$(list_tracked_files) || {
        echo "Error: Failed to read tracked files" >&2
        return 1
    }

    if [[ -z "$files" ]]; then
        echo "No files tracked"
        return 0
    fi

    # Step 6: Copy files to repository
    echo
    echo "Syncing files to repository..."
    local files_changed=0
    local files_copied=0

    while IFS= read -r file; do
        local path repo_path type
        path=$(echo "$file" | jq -r '.path')
        repo_path=$(echo "$file" | jq -r '.repo_path')
        type=$(echo "$file" | jq -r '.type')

        local dest="$dotfiles_path/$repo_path"

        # Check if source exists
        if [[ ! -e "$path" ]]; then
            echo "  ⚠ Skipping (not found): $path"
            continue
        fi

        # Check if files are different
        if files_are_same "$path" "$dest"; then
            echo "  ✓ Up to date: $repo_path"
            continue
        fi

        files_changed=$((files_changed + 1))

        if [[ "$dry_run" == "true" ]]; then
            echo "  [DRY RUN] Would copy: $path → $repo_path"
            continue
        fi

        # Copy based on type
        echo "  → Copying: $repo_path"
        if [[ "$type" == "directory" ]]; then
            if copy_directory "$path" "$dest"; then
                files_copied=$((files_copied + 1))
            else
                echo "    Error: Failed to copy directory" >&2
            fi
        else
            if copy_file "$path" "$dest"; then
                files_copied=$((files_copied + 1))
            else
                echo "    Error: Failed to copy file" >&2
            fi
        fi
    done <<< "$files"

    echo
    if [[ $files_changed -eq 0 ]]; then
        echo "All files up to date"
        return 0
    fi

    if [[ "$dry_run" == "true" ]]; then
        echo "[DRY RUN] Would sync $files_changed file(s) to repository"
        return 0
    fi

    echo "Synced $files_copied file(s) to repository"

    # Step 7: Stage changes
    echo
    echo "Staging changes..."
    cd "$repo_root" || return 1

    if ! stage_all; then
        echo "Error: Failed to stage changes" >&2
        return 1
    fi

    # Step 8: Check if there are changes to commit
    if ! has_uncommitted_changes && ! has_untracked_files; then
        echo "No changes to commit"
        return 0
    fi

    # Step 9: Commit
    local commit_message
    commit_message="Updated dotfiles on $(date +%Y-%m-%d)"
    echo "Creating commit..."

    if ! commit_changes "$commit_message"; then
        echo "Error: Failed to create commit" >&2
        return 1
    fi

    echo "✓ Committed: $commit_message"

    # Step 10: Push to remote
    echo
    echo "Pushing to remote..."

    if ! push_branch "$remote" "$branch"; then
        echo "Error: Failed to push to remote" >&2
        echo "Your changes are committed locally but not pushed" >&2
        return 1
    fi

    echo "✓ Pushed to $remote/$branch"

    # Step 11: Update sync times in config
    echo
    echo "Updating sync times..."
    local new_config
    new_config=$(read_config) || return 1

    while IFS= read -r file; do
        local path
        path=$(echo "$file" | jq -r '.path')

        if [[ -e "$path" ]]; then
            new_config=$(echo "$new_config" | jq \
                --arg path "$path" \
                --arg synced_at "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
                '(.files[] | select(.path == $path) | .last_synced) = $synced_at')
        fi
    done <<< "$files"

    write_config "$new_config"

    echo
    echo "✓ Push complete"
    return 0
}

# get_push_status - Show what would be pushed
# input: "show files that would be pushed without actually pushing"
# Args: $1 - repo root path
# Returns: 0 on success
get_push_status() {
    local repo_root="$1"

    # Get config values
    local dotfiles_dir
    dotfiles_dir=$(get_dotfiles_dir) || return 1
    local dotfiles_path="$repo_root/$dotfiles_dir"

    # Get tracked files
    local files
    files=$(list_tracked_files) || {
        echo "Error: Failed to read tracked files" >&2
        return 1
    }

    if [[ -z "$files" ]]; then
        echo "No files tracked"
        return 0
    fi

    echo "Files that will be pushed:"
    echo

    local has_changes=0

    while IFS= read -r file; do
        local path repo_path type
        path=$(echo "$file" | jq -r '.path')
        repo_path=$(echo "$file" | jq -r '.repo_path')
        type=$(echo "$file" | jq -r '.type')

        local dest="$dotfiles_path/$repo_path"

        # Check if source exists
        if [[ ! -e "$path" ]]; then
            echo "  ⚠ Missing: $path"
            has_changes=1
            continue
        fi

        # Check if files are different
        if ! files_are_same "$path" "$dest"; then
            echo "  ✎ Modified: $repo_path"
            has_changes=1
        fi
    done <<< "$files"

    if [[ $has_changes -eq 0 ]]; then
        echo "  No changes"
    fi

    echo
    return 0
}
