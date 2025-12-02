#!/usr/bin/env bash
# lib/commands/commands.sh - Command orchestrations

set -euo pipefail

# Source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../core/paths.sh"
source "$SCRIPT_DIR/../core/config.sh"
source "$SCRIPT_DIR/../core/git.sh"
source "$SCRIPT_DIR/../core/files.sh"
source "$SCRIPT_DIR/../workflows/track.sh"
source "$SCRIPT_DIR/../workflows/push.sh"
source "$SCRIPT_DIR/../workflows/pull.sh"

# Get repo root (directory containing .git)
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# cmd_init - Initialize a new dotdex configuration
# input: "initialize new dotdex repository and config"
# Args: $1 - repository URL (optional) or --from-repo flag, $2 - branch (optional)
# Returns: 0 on success, 1 on failure
cmd_init() {
    local from_repo=false
    local repo_url=""
    local branch="main"

    # Parse arguments
    if [[ "$1" == "--from-repo" ]]; then
        from_repo=true
        shift
    else
        repo_url="${1:-}"
        branch="${2:-main}"
    fi

    # Bootstrap from repository if --from-repo flag is set
    if [[ "$from_repo" == true ]]; then
        echo "Bootstrapping configuration from repository..."

        if ! bootstrap_config "$REPO_ROOT"; then
            return 1
        fi

        # Read bootstrapped config to show details
        local config
        config=$(read_config) || return 1
        repo_url=$(echo "$config" | jq -r '.repository.url')
        branch=$(echo "$config" | jq -r '.repository.branch')

        echo "✓ Bootstrapped dotdex configuration from repository"
        echo "  Repository: $repo_url"
        echo "  Branch: $branch"
        echo "  Config: $DOTDEX_CONFIG"
        echo
        echo "Next steps:"
        echo "  Run 'dotdex pull' to sync tracked files to your home directory"
        return 0
    fi

    # Original init logic for creating new config
    # Check if config already exists
    if [[ -f "$DOTDEX_CONFIG" ]]; then
        echo "Error: Configuration already exists at $DOTDEX_CONFIG" >&2
        echo "Remove it first if you want to reinitialize" >&2
        return 1
    fi

    # If no repo URL provided, try to get it from git
    if [[ -z "$repo_url" ]]; then
        if is_git_repo && cd "$REPO_ROOT"; then
            repo_url=$(git remote get-url origin 2>/dev/null || echo "")
        fi

        if [[ -z "$repo_url" ]]; then
            echo "Error: Repository URL required" >&2
            echo "Usage: dotdex init [--from-repo] | <repository-url> [branch]" >&2
            return 1
        fi
    fi

    # Create config
    local config
    config=$(init_config "$repo_url" "$branch" "dotfiles") || {
        echo "Error: Failed to create config" >&2
        return 1
    }

    # Write config
    if ! write_config "$config"; then
        echo "Error: Failed to write config" >&2
        return 1
    fi

    echo "✓ Initialized dotdex configuration"
    echo "  Repository: $repo_url"
    echo "  Branch: $branch"
    echo "  Config: $DOTDEX_CONFIG"
    echo
    echo "Next steps:"
    echo "  1. Track files: dotdex track <path>"
    echo "  2. Push to repository: dotdex push"
    return 0
}

# cmd_track - Track a new file
# input: "track new file with validation"
# Args: $1 - path to track
# Returns: 0 on success, 1 on failure
cmd_track() {
    local path="${1:-}"

    if [[ -z "$path" ]]; then
        echo "Error: Path required" >&2
        echo "Usage: dotdex track <path>" >&2
        return 1
    fi

    track_file_workflow "$path"
}

# cmd_untrack - Untrack a file
# input: "untrack file and remove from config"
# Args: $1 - path to untrack
# Returns: 0 on success, 1 on failure
cmd_untrack() {
    local path="${1:-}"

    if [[ -z "$path" ]]; then
        echo "Error: Path required" >&2
        echo "Usage: dotdex untrack <path>" >&2
        return 1
    fi

    untrack_file_workflow "$path"
}

# cmd_list - List all tracked files
# input: "list all tracked files with status"
# Returns: 0 on success
cmd_list() {
    list_tracked_files_workflow
}

# cmd_verify - Verify all tracked files
# input: "verify all tracked files exist and are valid"
# Returns: 0 on success
cmd_verify() {
    verify_tracked_files_workflow
}

# cmd_status - Show sync status
# input: "show what files have changed"
# Returns: 0 on success
cmd_status() {
    echo "=== Push Status (local → repository) ==="
    get_push_status "$REPO_ROOT"
    echo
    echo "=== Pull Status (repository → local) ==="
    get_pull_status "$REPO_ROOT"
}

# cmd_diff - Show diff for a specific file
# input: "show diff between local and repo version of file"
# Args: $1 - path or repo_path
# Returns: 0 on success
cmd_diff() {
    local path="${1:-}"

    if [[ -z "$path" ]]; then
        echo "Error: Path required" >&2
        echo "Usage: dotdex diff <path>" >&2
        return 1
    fi

    # Normalize and get file info
    local abs_path
    abs_path=$(normalize_path "$path")

    local file_info
    if ! file_info=$(get_tracked_file "$abs_path" 2>/dev/null); then
        echo "Error: File is not tracked: $abs_path" >&2
        return 1
    fi

    local repo_path type
    repo_path=$(echo "$file_info" | jq -r '.repo_path')
    type=$(echo "$file_info" | jq -r '.type')

    local dotfiles_dir
    dotfiles_dir=$(get_dotfiles_dir) || return 1
    local repo_file="$REPO_ROOT/$dotfiles_dir/$repo_path"

    echo "Diff for: $repo_path"
    echo "Local:      $abs_path"
    echo "Repository: $repo_file"
    echo

    if [[ "$type" == "file" ]]; then
        if [[ -f "$abs_path" ]] && [[ -f "$repo_file" ]]; then
            get_file_diff "$abs_path" "$repo_file" || {
                echo "Files are identical"
            }
        else
            echo "Error: Cannot diff - file missing or type mismatch" >&2
            return 1
        fi
    elif [[ "$type" == "directory" ]]; then
        if [[ -d "$abs_path" ]] && [[ -d "$repo_file" ]]; then
            get_directory_diff "$abs_path" "$repo_file"
        else
            echo "Error: Cannot diff - directory missing or type mismatch" >&2
            return 1
        fi
    fi

    return 0
}

# cmd_push - Push local changes to repository
# input: "push local dotfiles to repository"
# Args: $1 - optional --dry-run flag
# Returns: 0 on success
cmd_push() {
    local dry_run="false"

    if [[ "${1:-}" == "--dry-run" ]]; then
        dry_run="true"
        echo "=== DRY RUN MODE ==="
        echo
    fi

    push_workflow "$REPO_ROOT" "$dry_run"
}

# cmd_pull - Pull changes from repository
# input: "pull dotfiles from repository"
# Args: $1 - optional --dry-run flag
# Returns: 0 on success
cmd_pull() {
    local dry_run="false"

    if [[ "${1:-}" == "--dry-run" ]]; then
        dry_run="true"
        echo "=== DRY RUN MODE ==="
        echo
    fi

    # Check if config exists
    if [[ ! -f "$DOTDEX_CONFIG" ]]; then
        # Check if repo has config to bootstrap from
        if [[ -f "$REPO_ROOT/dotfiles/.dotdex.json" ]]; then
            echo "Error: No configuration found at $DOTDEX_CONFIG" >&2
            echo >&2
            echo "It looks like you're on a new machine. Bootstrap your config first:" >&2
            echo "  dotdex init --from-repo" >&2
            echo >&2
            echo "Then run 'dotdex pull' to sync your dotfiles." >&2
            return 1
        else
            echo "Error: No configuration found at $DOTDEX_CONFIG" >&2
            echo "Initialize dotdex first: dotdex init <repository-url>" >&2
            return 1
        fi
    fi

    pull_workflow "$REPO_ROOT" "$dry_run"
}

# cmd_sync - Bidirectional sync (pull then push)
# input: "sync dotfiles bidirectionally"
# Args: $1 - optional --dry-run flag
# Returns: 0 on success
cmd_sync() {
    local dry_run="false"

    if [[ "${1:-}" == "--dry-run" ]]; then
        dry_run="true"
        echo "=== DRY RUN MODE ==="
        echo
    fi

    echo "Step 1/2: Pulling from repository..."
    echo
    if ! pull_workflow "$REPO_ROOT" "$dry_run"; then
        echo
        echo "Error: Pull failed" >&2
        return 1
    fi

    echo
    echo "Step 2/2: Pushing to repository..."
    echo
    if ! push_workflow "$REPO_ROOT" "$dry_run"; then
        echo
        echo "Error: Push failed" >&2
        return 1
    fi

    echo
    echo "✓ Sync complete"
    return 0
}

# cmd_help - Show help message
# input: "show help message with all commands"
# Returns: 0
cmd_help() {
    cat <<EOF
dotdex - Dotfiles management tool

USAGE:
    dotdex <command> [args]

COMMANDS:
    init [url] [branch]     Initialize dotdex configuration
    init --from-repo        Bootstrap config from cloned repository
    track <path>            Track a new file or directory
    untrack <path>          Stop tracking a file or directory
    list                    List all tracked files
    verify                  Verify all tracked files exist and are valid
    status                  Show what files have changed
    diff <path>             Show diff for a specific file
    push [--dry-run]        Push local changes to repository
    pull [--dry-run]        Pull changes from repository
    sync [--dry-run]        Bidirectional sync (pull then push)
    help                    Show this help message

EXAMPLES:
    # Initialize new dotfiles repo
    dotdex init git@github.com:user/dotfiles.git

    # Bootstrap on new machine (after git clone)
    dotdex init --from-repo
    dotdex pull

    # Track files
    dotdex track ~/.zshrc
    dotdex track ~/.emacs.d

    # Check status
    dotdex status
    dotdex diff ~/.zshrc

    # Sync
    dotdex push
    dotdex pull
    dotdex sync

    # Dry run
    dotdex push --dry-run
    dotdex pull --dry-run

CONFIGURATION:
    Config file: $DOTDEX_CONFIG
    Repository: $(get_repo_url 2>/dev/null || echo "Not configured")
    Branch: $(get_repo_branch 2>/dev/null || echo "Not configured")

FILES:
    Your dotfiles are stored in: $REPO_ROOT/dotfiles/
    The repository structure mirrors your home directory.

EOF
    return 0
}
