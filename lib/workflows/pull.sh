#!/usr/bin/env bash
# lib/workflows/pull.sh - Workflow composition for pulling changes

set -euo pipefail

# Source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../core/paths.sh"
source "$SCRIPT_DIR/../core/config.sh"
source "$SCRIPT_DIR/../core/git.sh"
source "$SCRIPT_DIR/../core/files.sh"

# resolve_conflict_interactive - Interactive conflict resolution
# input: "interactively resolve conflict for a file"
# Args: $1 - local file path, $2 - repo file path, $3 - repo path for display
# Returns: 0 if resolved, 1 if aborted
resolve_conflict_interactive() {
    local local_file="$1"
    local repo_file="$2"
    local repo_path="$3"

    echo
    echo "==================================================================="
    echo "CONFLICT: $repo_path"
    echo "==================================================================="
    echo
    echo "Both local and repository versions have been modified."
    echo
    echo "Local:      $local_file"
    echo "Repository: $repo_file"
    echo
    echo "Options:"
    echo "  1) Keep local version (overwrite repo with local)"
    echo "  2) Keep repository version (overwrite local with repo)"
    echo "  3) Show diff"
    echo "  4) Open both in \$EDITOR"
    echo "  5) Skip this file"
    echo "  6) Abort pull"
    echo

    while true; do
        read -rp "Choose an option [1-6]: " choice

        case "$choice" in
            1)
                echo "→ Keeping local version"
                # Copy local to repo
                if [[ -d "$local_file" ]]; then
                    copy_directory "$local_file" "$repo_file" >/dev/null
                else
                    copy_file "$local_file" "$repo_file" >/dev/null
                fi
                return 0
                ;;
            2)
                echo "→ Keeping repository version"
                # Will be copied during normal pull process
                return 0
                ;;
            3)
                echo
                if [[ -f "$local_file" ]] && [[ -f "$repo_file" ]]; then
                    get_file_diff "$repo_file" "$local_file" || true
                elif [[ -d "$local_file" ]] && [[ -d "$repo_file" ]]; then
                    get_directory_diff "$repo_file" "$local_file" || true
                else
                    echo "Cannot diff: type mismatch between local and repo"
                fi
                echo
                ;;
            4)
                local editor="${EDITOR:-nano}"
                echo "Opening files in $editor..."
                if [[ -f "$local_file" ]] && [[ -f "$repo_file" ]]; then
                    $editor "$local_file" "$repo_file"
                else
                    echo "Cannot open: one or both paths are directories"
                fi
                echo
                echo "After editing, choose option 1 or 2 to continue"
                ;;
            5)
                echo "→ Skipping file"
                return 1
                ;;
            6)
                echo "→ Aborting pull"
                return 2
                ;;
            *)
                echo "Invalid choice. Please choose 1-6."
                ;;
        esac
    done
}

# pull_workflow - Complete workflow for pulling changes from repository
# input: "pull dotfiles from repository: fetch, check conflicts, copy to local"
# Args: $1 - repo root path, $2 - dry run flag (true/false)
# Returns: 0 on success, 1 on failure, 2 if conflicts need resolution
pull_workflow() {
    local repo_root="$1"
    local dry_run="${2:-false}"

    # Step 1: Validate we're in a git repo
    cd "$repo_root" || return 1
    if ! is_git_repo; then
        echo "Error: Not a git repository: $repo_root" >&2
        return 1
    fi

    # Step 2: Check for uncommitted changes
    if has_uncommitted_changes || has_untracked_files; then
        echo "Error: Repository has uncommitted changes" >&2
        echo "Please commit or stash changes first" >&2
        return 1
    fi

    # Step 3: Get config values
    local dotfiles_dir branch remote
    dotfiles_dir=$(get_dotfiles_dir) || return 1
    branch=$(get_repo_branch) || return 1
    remote="origin"

    local dotfiles_path="$repo_root/$dotfiles_dir"

    # Step 4: Fetch and pull from remote
    echo "Fetching from remote..."
    if ! fetch_remote "$remote"; then
        echo "Error: Failed to fetch from remote" >&2
        return 1
    fi

    # Check if behind remote
    if is_behind_remote "$remote" "$branch" 2>/dev/null; then
        local behind_count
        behind_count=$(get_commit_count_behind "$remote" "$branch")
        echo "Pulling $behind_count commit(s) from remote..."

        # Attempt pull
        local pull_result
        pull_branch "$remote" "$branch" >/dev/null 2>&1
        pull_result=$?

        if [[ $pull_result -eq 2 ]]; then
            # Merge conflicts
            echo
            echo "==================================================================="
            echo "ERROR: Merge conflicts detected"
            echo "==================================================================="
            echo
            echo "The following files have conflicts:"
            get_conflicted_files
            echo
            echo "Please resolve conflicts manually:"
            echo "  1. Fix conflicts in the files listed above"
            echo "  2. Run: git add <file>"
            echo "  3. Run: git commit"
            echo "  4. Run: dotdex pull again"
            echo
            echo "Or to abort the merge:"
            echo "  git merge --abort"
            echo
            return 2
        elif [[ $pull_result -ne 0 ]]; then
            echo "Error: Failed to pull from remote" >&2
            return 1
        fi

        echo "✓ Pulled changes from remote"
    else
        echo "Already up to date with remote"
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

    # Step 6: Check for conflicts and copy files
    echo
    echo "Syncing files from repository to local system..."
    local files_changed=0
    local files_copied=0
    local conflicts_found=0

    while IFS= read -r file; do
        local path repo_path type
        path=$(echo "$file" | jq -r '.path')
        repo_path=$(echo "$file" | jq -r '.repo_path')
        type=$(echo "$file" | jq -r '.type')

        # Normalize path (expands ~ if present)
        path=$(normalize_path "$path")

        local source="$dotfiles_path/$repo_path"

        # Check if source exists in repo
        if [[ ! -e "$source" ]]; then
            echo "  ⚠ Skipping (not in repo): $repo_path"
            continue
        fi

        # Check if files are the same
        if files_are_same "$source" "$path"; then
            echo "  ✓ Up to date: $repo_path"
            continue
        fi

        # Check for conflicts (both local and repo have changes)
        local has_conflict=false
        if [[ -e "$path" ]]; then
            # Both exist and are different - potential conflict
            # Check if local file is newer than last sync
            local last_synced
            last_synced=$(echo "$file" | jq -r '.last_synced // empty')

            if [[ -n "$last_synced" ]]; then
                # We have sync history, check if local was modified after last sync
                local local_mtime synced_timestamp
                local_mtime=$(get_file_modification_time "$path")
                synced_timestamp=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$last_synced" "+%s" 2>/dev/null || echo "0")

                if [[ $local_mtime -gt $synced_timestamp ]]; then
                    has_conflict=true
                    conflicts_found=$((conflicts_found + 1))
                fi
            fi
        fi

        files_changed=$((files_changed + 1))

        if [[ "$dry_run" == "true" ]]; then
            if [[ "$has_conflict" == "true" ]]; then
                echo "  [DRY RUN] Would prompt for conflict: $repo_path"
            else
                echo "  [DRY RUN] Would copy: $repo_path → $path"
            fi
            continue
        fi

        # Handle conflict interactively
        if [[ "$has_conflict" == "true" ]]; then
            resolve_conflict_interactive "$path" "$source" "$repo_path"
            local resolve_result=$?

            if [[ $resolve_result -eq 2 ]]; then
                echo
                echo "Pull aborted by user"
                return 1
            elif [[ $resolve_result -eq 1 ]]; then
                echo "  ⊘ Skipped: $repo_path"
                continue
            fi
        fi

        # Copy from repo to local
        echo "  ← Copying: $repo_path → local"

        # Create backup if file exists
        if [[ -e "$path" ]]; then
            local backup_path
            backup_path=$(create_backup "$path") || {
                echo "    Warning: Failed to create backup" >&2
            }
            if [[ -n "$backup_path" ]]; then
                echo "    Backup: $backup_path"
            fi
        fi

        # Copy based on type
        if [[ "$type" == "directory" ]]; then
            if copy_directory "$source" "$path"; then
                files_copied=$((files_copied + 1))
            else
                echo "    Error: Failed to copy directory" >&2
            fi
        else
            if copy_file "$source" "$path"; then
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
        echo "[DRY RUN] Would sync $files_changed file(s) from repository"
        if [[ $conflicts_found -gt 0 ]]; then
            echo "[DRY RUN] Would prompt for $conflicts_found conflict(s)"
        fi
        return 0
    fi

    echo "Synced $files_copied file(s) from repository"

    # Step 7: Update sync times in config
    echo
    echo "Updating sync times..."
    local new_config
    new_config=$(read_config) || return 1

    while IFS= read -r file; do
        local path
        path=$(echo "$file" | jq -r '.path')

        new_config=$(echo "$new_config" | jq \
            --arg path "$path" \
            --arg synced_at "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
            '(.files[] | select(.path == $path) | .last_synced) = $synced_at')
    done <<< "$files"

    write_config "$new_config"

    echo
    echo "✓ Pull complete"
    return 0
}

# get_pull_status - Show what would be pulled
# input: "show files that would be pulled without actually pulling"
# Args: $1 - repo root path
# Returns: 0 on success
get_pull_status() {
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

    echo "Files that will be pulled:"
    echo

    local has_changes=0

    while IFS= read -r file; do
        local path repo_path
        path=$(echo "$file" | jq -r '.path')
        repo_path=$(echo "$file" | jq -r '.repo_path')

        # Normalize path (expands ~ if present)
        path=$(normalize_path "$path")

        local source="$dotfiles_path/$repo_path"

        # Check if source exists in repo
        if [[ ! -e "$source" ]]; then
            echo "  ⚠ Not in repo: $repo_path"
            has_changes=1
            continue
        fi

        # Check if files are different
        if ! files_are_same "$source" "$path"; then
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
