#!/usr/bin/env bash
# lib/core/config.sh - Pure functions for config operations

set -euo pipefail

# Source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/paths.sh"

# Default config location
DOTDEX_CONFIG="${DOTDEX_CONFIG:-$HOME/.dotdex.json}"
CONFIG_VERSION="2.0"

# init_config - Create initial config structure
# input: "create initial config with repo URL and branch"
# Args: $1 - repository URL, $2 - branch name (default: main), $3 - dotfiles directory (default: dotfiles)
# Returns: 0 on success, 1 on failure
# Outputs: JSON config string to stdout
init_config() {
    local repo_url="$1"
    local branch="${2:-main}"
    local dotfiles_dir="${3:-dotfiles}"

    jq -n \
        --arg version "$CONFIG_VERSION" \
        --arg url "$repo_url" \
        --arg branch "$branch" \
        --arg dotfiles_dir "$dotfiles_dir" \
        '{
            version: $version,
            repository: {
                url: $url,
                branch: $branch,
                dotfiles_dir: $dotfiles_dir
            },
            files: []
        }'
}

# read_config - Read and validate config file
# input: "read config file and return contents"
# Returns: 0 on success, 1 on failure
# Outputs: Config JSON to stdout
read_config() {
    if [[ ! -f "$DOTDEX_CONFIG" ]]; then
        echo "Error: Config file not found at $DOTDEX_CONFIG" >&2
        return 1
    fi

    if ! jq empty "$DOTDEX_CONFIG" 2>/dev/null; then
        echo "Error: Config file is not valid JSON" >&2
        return 1
    fi

    jq '.' "$DOTDEX_CONFIG"
}

# write_config - Write config to file atomically
# input: "write config JSON to file atomically"
# Args: $1 - JSON config string
# Returns: 0 on success, 1 on failure
write_config() {
    local config_json="$1"
    local temp_file="${DOTDEX_CONFIG}.tmp.$$"

    # Validate JSON before writing
    if ! echo "$config_json" | jq empty 2>/dev/null; then
        echo "Error: Invalid JSON provided to write_config" >&2
        return 1
    fi

    # Write to temp file
    echo "$config_json" > "$temp_file" || return 1

    # Atomic move
    mv "$temp_file" "$DOTDEX_CONFIG" || {
        rm -f "$temp_file"
        return 1
    }
}

# bootstrap_config - Copy config from repo to home directory
# input: "bootstrap dotdex config from repository"
# Args: $1 - repo root path
# Returns: 0 on success, 1 on failure
bootstrap_config() {
    local repo_root="$1"
    local repo_config="$repo_root/dotfiles/.dotdex.json"

    # Check if config already exists
    if [[ -f "$DOTDEX_CONFIG" ]]; then
        echo "Error: Configuration already exists at $DOTDEX_CONFIG" >&2
        echo "Remove it first if you want to bootstrap again" >&2
        return 1
    fi

    # Check if repo config exists
    if [[ ! -f "$repo_config" ]]; then
        echo "Error: No .dotdex.json found in repository at $repo_config" >&2
        return 1
    fi

    # Validate repo config is valid JSON
    if ! jq empty "$repo_config" 2>/dev/null; then
        echo "Error: Repository config is not valid JSON: $repo_config" >&2
        return 1
    fi

    # Copy to home directory
    cp "$repo_config" "$DOTDEX_CONFIG" || {
        echo "Error: Failed to copy config to $DOTDEX_CONFIG" >&2
        return 1
    }

    return 0
}

# get_config_value - Extract a value from config
# input: "extract value from config using jq query"
# Args: $1 - jq query (e.g., ".repository.url")
# Returns: 0 on success, 1 on failure
# Outputs: Query result to stdout
get_config_value() {
    local query="$1"
    local config
    config=$(read_config) || return 1

    echo "$config" | jq -r "$query"
}

# add_tracked_file - Add file to tracked files list
# input: "add file to config's tracked files list"
# Args: $1 - absolute path, $2 - repo path, $3 - type (file/directory)
# Returns: 0 on success, 1 on failure
# Outputs: Updated config JSON to stdout
add_tracked_file() {
    local abs_path="$1"
    local repo_path="$2"
    local type="$3"
    local timestamp
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    local config
    config=$(read_config) || return 1

    # Convert absolute path to tilde path for portability
    local tilde_path
    tilde_path=$(abs_path_to_tilde "$abs_path")

    # Check if already tracked (check both formats for backwards compatibility)
    if echo "$config" | jq -e --arg path "$abs_path" --arg tilde "$tilde_path" \
        '.files[] | select(.path == $path or .path == $tilde)' >/dev/null 2>&1; then
        echo "Error: File already tracked: $abs_path" >&2
        return 1
    fi

    # Add new file entry with tilde path
    echo "$config" | jq \
        --arg path "$tilde_path" \
        --arg repo_path "$repo_path" \
        --arg type "$type" \
        --arg tracked_at "$timestamp" \
        '.files += [{
            path: $path,
            repo_path: $repo_path,
            type: $type,
            tracked_at: $tracked_at,
            last_synced: null
        }]'
}

# remove_tracked_file - Remove file from tracked files list
# input: "remove file from config's tracked files list"
# Args: $1 - absolute path or repo path
# Returns: 0 on success, 1 on failure
# Outputs: Updated config JSON to stdout
remove_tracked_file() {
    local path="$1"
    local config
    config=$(read_config) || return 1

    # Normalize path to tilde format for matching
    local normalized_path tilde_path
    normalized_path=$(normalize_path "$path" 2>/dev/null || echo "$path")
    tilde_path=$(abs_path_to_tilde "$normalized_path")

    # Try to match by path (both formats), repo_path, or exact input
    echo "$config" | jq \
        --arg path "$path" \
        --arg normalized "$normalized_path" \
        --arg tilde "$tilde_path" \
        '.files = [.files[] | select(.path != $path and .path != $normalized and .path != $tilde and .repo_path != $path)]'
}

# update_sync_time - Update last_synced timestamp for a file
# input: "update last sync timestamp for tracked file"
# Args: $1 - absolute path
# Returns: 0 on success, 1 on failure
# Outputs: Updated config JSON to stdout
update_sync_time() {
    local abs_path="$1"
    local timestamp
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    local config
    config=$(read_config) || return 1

    echo "$config" | jq \
        --arg path "$abs_path" \
        --arg synced_at "$timestamp" \
        '(.files[] | select(.path == $path) | .last_synced) = $synced_at'
}

# list_tracked_files - Get list of all tracked files
# input: "get list of all tracked files from config"
# Returns: 0 on success, 1 on failure
# Outputs: Array of file objects as JSON
list_tracked_files() {
    local config
    config=$(read_config) || return 1

    echo "$config" | jq -c '.files[]'
}

# get_tracked_file - Get specific tracked file info
# input: "get tracked file info by path"
# Args: $1 - absolute path or repo path
# Returns: 0 on success, 1 if not found
# Outputs: File object as JSON
get_tracked_file() {
    local path="$1"
    local config
    config=$(read_config) || return 1

    # Normalize input to tilde path for comparison
    local normalized_path
    normalized_path=$(normalize_path "$path")
    local tilde_path
    tilde_path=$(abs_path_to_tilde "$normalized_path")

    local result
    result=$(echo "$config" | jq -r --arg path "$path" --arg tilde "$tilde_path" \
        '.files[] | select(.path == $path or .path == $tilde or .repo_path == $path)')

    if [[ -z "$result" ]]; then
        return 1
    fi

    echo "$result"
}

# validate_config - Validate config file structure
# input: "validate config file has correct structure and version"
# Returns: 0 if valid, 1 if invalid
validate_config() {
    local config
    config=$(read_config) || return 1

    # Check version
    local version
    version=$(echo "$config" | jq -r '.version // empty')
    if [[ "$version" != "$CONFIG_VERSION" ]]; then
        echo "Error: Config version mismatch. Expected $CONFIG_VERSION, got $version" >&2
        return 1
    fi

    # Check required fields
    local required_fields=(".repository.url" ".repository.branch" ".repository.dotfiles_dir" ".files")
    for field in "${required_fields[@]}"; do
        if ! echo "$config" | jq -e "$field" >/dev/null 2>&1; then
            echo "Error: Missing required field: $field" >&2
            return 1
        fi
    done

    return 0
}

# get_repo_url - Get repository URL from config
# input: "get repository URL from config"
# Returns: 0 on success, 1 on failure
# Outputs: Repository URL to stdout
get_repo_url() {
    get_config_value ".repository.url"
}

# get_repo_branch - Get repository branch from config
# input: "get repository branch from config"
# Returns: 0 on success, 1 on failure
# Outputs: Branch name to stdout
get_repo_branch() {
    get_config_value ".repository.branch"
}

# get_dotfiles_dir - Get dotfiles directory name from config
# input: "get dotfiles directory name from config"
# Returns: 0 on success, 1 on failure
# Outputs: Dotfiles directory name to stdout
get_dotfiles_dir() {
    get_config_value ".repository.dotfiles_dir"
}
