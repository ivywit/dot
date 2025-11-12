#!/usr/bin/env bash
# lib/core/paths.sh - Pure functions for path operations

set -euo pipefail

# normalize_path - Convert path to absolute, expanded form
# input: "normalize path '~/.zshrc' to absolute form"
# Args: $1 - path (can be relative, contain ~, etc.)
# Returns: 0 on success, 1 on failure
# Outputs: Normalized absolute path to stdout
normalize_path() {
    local path="$1"

    # Expand tilde
    path="${path/#\~/$HOME}"

    # Convert to absolute path
    if [[ ! "$path" = /* ]]; then
        path="$PWD/$path"
    fi

    # Normalize (remove .., ., etc.)
    if command -v realpath >/dev/null 2>&1; then
        realpath -m "$path" 2>/dev/null || echo "$path"
    else
        # Fallback for systems without realpath
        python3 -c "import os; print(os.path.normpath('$path'))" 2>/dev/null || echo "$path"
    fi
}

# validate_path_exists - Check if path exists
# input: "validate that path exists"
# Args: $1 - path to validate
# Returns: 0 if exists, 1 if not
validate_path_exists() {
    local path="$1"
    [[ -e "$path" ]]
}

# validate_path_in_home - Check if path is under home directory
# input: "validate that path is within home directory"
# Args: $1 - path to validate
# Returns: 0 if in home, 1 if not
validate_path_in_home() {
    local path="$1"
    local normalized
    normalized=$(normalize_path "$path")

    [[ "$normalized" == "$HOME"* ]]
}

# is_directory - Check if path is a directory
# input: "check if path is a directory"
# Args: $1 - path to check
# Returns: 0 if directory, 1 if not
is_directory() {
    local path="$1"
    [[ -d "$path" ]]
}

# is_file - Check if path is a regular file
# input: "check if path is a regular file"
# Args: $1 - path to check
# Returns: 0 if file, 1 if not
is_file() {
    local path="$1"
    [[ -f "$path" ]]
}

# path_to_repo_path - Convert absolute path to repo-relative path
# input: "convert absolute home path to repo dotfiles path"
# Args: $1 - absolute path (e.g., /Users/ivy/.zshrc)
# Returns: 0 on success, 1 on failure
# Outputs: Repo-relative path (e.g., .zshrc)
path_to_repo_path() {
    local abs_path="$1"
    local normalized
    normalized=$(normalize_path "$abs_path")

    # Remove HOME prefix to get relative path
    if [[ "$normalized" == "$HOME/"* ]]; then
        echo "${normalized#$HOME/}"
    elif [[ "$normalized" == "$HOME" ]]; then
        echo "."
    else
        echo "$normalized"
    fi
}

# repo_path_to_abs_path - Convert repo-relative path to absolute path
# input: "convert repo dotfiles path to absolute home path"
# Args: $1 - repo-relative path (e.g., .zshrc)
# Returns: 0 on success
# Outputs: Absolute path (e.g., /Users/ivy/.zshrc)
repo_path_to_abs_path() {
    local repo_path="$1"

    if [[ "$repo_path" == "." ]]; then
        echo "$HOME"
    else
        normalize_path "$HOME/$repo_path"
    fi
}

# get_path_type - Determine if path is file or directory
# input: "determine if path is file or directory"
# Args: $1 - path to check
# Returns: 0 on success, 1 if path doesn't exist
# Outputs: "file" or "directory"
get_path_type() {
    local path="$1"

    if [[ ! -e "$path" ]]; then
        return 1
    fi

    if [[ -d "$path" ]]; then
        echo "directory"
    else
        echo "file"
    fi
}

# validate_not_symlink - Ensure path is not a symbolic link
# input: "validate that path is not a symbolic link"
# Args: $1 - path to validate
# Returns: 0 if not a symlink, 1 if it is
validate_not_symlink() {
    local path="$1"
    [[ ! -L "$path" ]]
}
