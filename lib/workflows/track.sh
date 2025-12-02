#!/usr/bin/env bash
# lib/workflows/track.sh - Workflow composition for tracking files

set -euo pipefail

# Source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../core/paths.sh"
source "$SCRIPT_DIR/../core/config.sh"

# track_file_workflow - Complete workflow for tracking a new file
# input: "track new file: validate, normalize path, update config"
# Args: $1 - path to track
# Returns: 0 on success, 1 on failure
track_file_workflow() {
    local path="$1"

    # Step 1: Normalize path
    local abs_path
    abs_path=$(normalize_path "$path") || {
        echo "Error: Failed to normalize path: $path" >&2
        return 1
    }

    # Step 2: Validate path exists
    if ! validate_path_exists "$abs_path"; then
        echo "Error: Path does not exist: $abs_path" >&2
        return 1
    fi

    # Step 3: Validate path is in home directory
    if ! validate_path_in_home "$abs_path"; then
        echo "Error: Path must be under home directory: $abs_path" >&2
        return 1
    fi

    # Step 4: Validate not a symlink
    if ! validate_not_symlink "$abs_path"; then
        echo "Error: Path is a symbolic link. Dotdex does not track symlinks: $abs_path" >&2
        return 1
    fi

    # Step 5: Get path type
    local type
    type=$(get_path_type "$abs_path") || {
        echo "Error: Failed to determine path type: $abs_path" >&2
        return 1
    }

    # Step 6: Convert to repo path
    local repo_path
    repo_path=$(path_to_repo_path "$abs_path") || {
        echo "Error: Failed to convert to repo path: $abs_path" >&2
        return 1
    }

    # Step 7: Check if already tracked
    if get_tracked_file "$abs_path" >/dev/null 2>&1; then
        echo "Error: File is already tracked: $abs_path" >&2
        return 1
    fi

    # Step 8: Add to config
    local new_config
    new_config=$(add_tracked_file "$abs_path" "$repo_path" "$type") || {
        echo "Error: Failed to add file to config" >&2
        return 1
    }

    # Step 9: Write config atomically
    if ! write_config "$new_config"; then
        echo "Error: Failed to write config" >&2
        return 1
    fi

    # Success
    echo "Tracked: $abs_path → $repo_path ($type)"
    echo "Run 'dotdex push' to sync this file to the repository"
    return 0
}

# untrack_file_workflow - Complete workflow for untracking a file
# input: "untrack file: validate, update config"
# Args: $1 - path to untrack
# Returns: 0 on success, 1 on failure
untrack_file_workflow() {
    local path="$1"

    # Step 1: Normalize path
    local abs_path
    abs_path=$(normalize_path "$path") || {
        echo "Error: Failed to normalize path: $path" >&2
        return 1
    }

    # Step 2: Check if tracked
    local file_info
    if ! file_info=$(get_tracked_file "$abs_path" 2>/dev/null); then
        echo "Error: File is not tracked: $abs_path" >&2
        return 1
    fi

    # Step 3: Get repo path for display
    local repo_path
    repo_path=$(echo "$file_info" | jq -r '.repo_path')

    # Step 4: Remove from config
    local new_config
    new_config=$(remove_tracked_file "$abs_path") || {
        echo "Error: Failed to remove file from config" >&2
        return 1
    }

    # Step 5: Write config atomically
    if ! write_config "$new_config"; then
        echo "Error: Failed to write config" >&2
        return 1
    fi

    # Success
    echo "Untracked: $abs_path (was: $repo_path)"
    echo "Run 'dotdex push' to remove this file from the repository"
    return 0
}

# list_tracked_files_workflow - List all tracked files with status
# input: "list all tracked files with paths and sync status"
# Returns: 0 on success
list_tracked_files_workflow() {
    local files
    files=$(list_tracked_files) || {
        echo "Error: Failed to read tracked files" >&2
        return 1
    }

    if [[ -z "$files" ]]; then
        echo "No files tracked"
        return 0
    fi

    echo "Tracked files:"
    echo

    while IFS= read -r file; do
        local path repo_path type tracked_at last_synced
        path=$(echo "$file" | jq -r '.path')
        repo_path=$(echo "$file" | jq -r '.repo_path')
        type=$(echo "$file" | jq -r '.type')
        tracked_at=$(echo "$file" | jq -r '.tracked_at')
        last_synced=$(echo "$file" | jq -r '.last_synced // "never"')

        # Normalize path (expands ~ if present)
        local normalized_path
        normalized_path=$(normalize_path "$path")

        # Check if file still exists
        local exists="✓"
        if [[ ! -e "$normalized_path" ]]; then
            exists="✗ (missing)"
        fi

        printf "  %s %s\n" "$exists" "$path"
        printf "    → %s (%s)\n" "$repo_path" "$type"
        printf "    Tracked: %s, Last synced: %s\n" "$tracked_at" "$last_synced"
        echo
    done <<< "$files"

    return 0
}

# verify_tracked_files_workflow - Verify all tracked files exist and are valid
# input: "verify all tracked files exist and paths are valid"
# Returns: 0 if all valid, 1 if any issues found
verify_tracked_files_workflow() {
    local files
    files=$(list_tracked_files) || {
        echo "Error: Failed to read tracked files" >&2
        return 1
    }

    if [[ -z "$files" ]]; then
        echo "No files tracked"
        return 0
    fi

    local has_issues=0
    echo "Verifying tracked files..."
    echo

    while IFS= read -r file; do
        local path repo_path type
        path=$(echo "$file" | jq -r '.path')
        repo_path=$(echo "$file" | jq -r '.repo_path')
        type=$(echo "$file" | jq -r '.type')

        # Normalize path (expands ~ if present)
        local normalized_path
        normalized_path=$(normalize_path "$path")

        # Check if path exists
        if [[ ! -e "$normalized_path" ]]; then
            echo "✗ $path"
            echo "  Issue: File does not exist"
            has_issues=1
            continue
        fi

        # Check if type matches
        local actual_type
        actual_type=$(get_path_type "$normalized_path")
        if [[ "$actual_type" != "$type" ]]; then
            echo "✗ $path"
            echo "  Issue: Type mismatch (config: $type, actual: $actual_type)"
            has_issues=1
            continue
        fi

        # Check if still in home directory
        if ! validate_path_in_home "$normalized_path"; then
            echo "✗ $path"
            echo "  Issue: Path is not under home directory"
            has_issues=1
            continue
        fi

        # Check if symlink
        if ! validate_not_symlink "$normalized_path"; then
            echo "✗ $path"
            echo "  Issue: Path has become a symbolic link"
            has_issues=1
            continue
        fi

        echo "✓ $path → $repo_path"
    done <<< "$files"

    echo

    if [[ $has_issues -eq 0 ]]; then
        echo "All tracked files are valid"
        return 0
    else
        echo "Some tracked files have issues"
        return 1
    fi
}
