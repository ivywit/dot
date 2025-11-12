#!/usr/bin/env bash
# lib/core/files.sh - Pure functions for file operations

set -euo pipefail

# files_are_same - Compare two files/directories for equality
# input: "compare two files or directories for equality"
# Args: $1 - path 1, $2 - path 2
# Returns: 0 if same, 1 if different
files_are_same() {
    local path1="$1"
    local path2="$2"

    # If both don't exist, they're the same
    if [[ ! -e "$path1" ]] && [[ ! -e "$path2" ]]; then
        return 0
    fi

    # If one exists and other doesn't, they're different
    if [[ ! -e "$path1" ]] || [[ ! -e "$path2" ]]; then
        return 1
    fi

    # If types differ (file vs directory), they're different
    if [[ -d "$path1" ]] && [[ ! -d "$path2" ]]; then
        return 1
    fi
    if [[ -f "$path1" ]] && [[ ! -f "$path2" ]]; then
        return 1
    fi

    # Compare files
    if [[ -f "$path1" ]]; then
        cmp -s "$path1" "$path2"
        return $?
    fi

    # Compare directories (check if rsync would change anything)
    if [[ -d "$path1" ]]; then
        # Use rsync dry-run to check differences
        local changes
        changes=$(rsync -rin --delete "$path1/" "$path2/" 2>/dev/null | grep -v "/$" | wc -l)
        [[ "$changes" -eq 0 ]]
        return $?
    fi

    return 1
}

# copy_file - Copy a file with error handling
# input: "copy file from source to destination"
# Args: $1 - source path, $2 - destination path
# Returns: 0 on success, 1 on failure
copy_file() {
    local src="$1"
    local dest="$2"

    if [[ ! -f "$src" ]]; then
        echo "Error: Source file does not exist: $src" >&2
        return 1
    fi

    # Create destination directory if needed
    local dest_dir
    dest_dir="$(dirname "$dest")"
    mkdir -p "$dest_dir" || return 1

    # Copy file preserving permissions
    cp -p "$src" "$dest" 2>&1
}

# copy_directory - Copy a directory with error handling
# input: "copy directory from source to destination"
# Args: $1 - source path, $2 - destination path
# Returns: 0 on success, 1 on failure
copy_directory() {
    local src="$1"
    local dest="$2"

    if [[ ! -d "$src" ]]; then
        echo "Error: Source directory does not exist: $src" >&2
        return 1
    fi

    # Create destination if needed
    mkdir -p "$dest" || return 1

    # Copy directory contents, excluding .git directories
    rsync -a --delete --exclude .git "$src/" "$dest/" 2>&1
}

# get_file_modification_time - Get file modification timestamp
# input: "get file modification time as unix timestamp"
# Args: $1 - file path
# Returns: 0 on success, 1 on failure
# Outputs: Unix timestamp
get_file_modification_time() {
    local file="$1"

    if [[ ! -e "$file" ]]; then
        echo "Error: File does not exist: $file" >&2
        return 1
    fi

    # Platform-specific stat command
    if [[ "$(uname)" == "Darwin" ]]; then
        stat -f "%m" "$file"
    else
        stat -c "%Y" "$file"
    fi
}

# file_is_newer - Check if file1 is newer than file2
# input: "check if file1 has newer modification time than file2"
# Args: $1 - file1 path, $2 - file2 path
# Returns: 0 if file1 is newer, 1 otherwise
file_is_newer() {
    local file1="$1"
    local file2="$2"

    # If file2 doesn't exist, file1 is "newer"
    if [[ ! -e "$file2" ]]; then
        return 0
    fi

    # If file1 doesn't exist, it's not newer
    if [[ ! -e "$file1" ]]; then
        return 1
    fi

    local time1 time2
    time1=$(get_file_modification_time "$file1") || return 1
    time2=$(get_file_modification_time "$file2") || return 1

    [[ "$time1" -gt "$time2" ]]
}

# get_file_diff - Get diff between two files
# input: "get diff between two files"
# Args: $1 - file1 path, $2 - file2 path
# Returns: 0 if different, 1 if same or error
# Outputs: Diff output
get_file_diff() {
    local file1="$1"
    local file2="$2"

    if [[ ! -f "$file1" ]] || [[ ! -f "$file2" ]]; then
        echo "Error: Both paths must be files" >&2
        return 1
    fi

    diff -u "$file1" "$file2" 2>/dev/null || true
}

# get_directory_diff - Get diff summary between two directories
# input: "get diff summary between two directories"
# Args: $1 - dir1 path, $2 - dir2 path
# Returns: 0 always
# Outputs: Diff summary
get_directory_diff() {
    local dir1="$1"
    local dir2="$2"

    if [[ ! -d "$dir1" ]] || [[ ! -d "$dir2" ]]; then
        echo "Error: Both paths must be directories" >&2
        return 1
    fi

    # Use rsync to show what would change
    rsync -rin --delete --exclude .git "$dir1/" "$dir2/" 2>/dev/null || true
}

# create_backup - Create a backup of a file or directory
# input: "create backup of file or directory"
# Args: $1 - path to backup
# Returns: 0 on success, 1 on failure
# Outputs: Backup path
create_backup() {
    local path="$1"
    local timestamp
    timestamp=$(date +"%Y%m%d_%H%M%S")
    local backup_path="${path}.backup.${timestamp}"

    if [[ -f "$path" ]]; then
        cp -p "$path" "$backup_path" || return 1
    elif [[ -d "$path" ]]; then
        cp -rp "$path" "$backup_path" || return 1
    else
        echo "Error: Path does not exist: $path" >&2
        return 1
    fi

    echo "$backup_path"
}

# ensure_directory_exists - Ensure directory exists, create if not
# input: "ensure directory exists, create if necessary"
# Args: $1 - directory path
# Returns: 0 on success, 1 on failure
ensure_directory_exists() {
    local dir="$1"

    if [[ -e "$dir" ]] && [[ ! -d "$dir" ]]; then
        echo "Error: Path exists but is not a directory: $dir" >&2
        return 1
    fi

    mkdir -p "$dir" 2>&1
}

# remove_file - Remove a file safely
# input: "remove file with validation"
# Args: $1 - file path
# Returns: 0 on success, 1 on failure
remove_file() {
    local path="$1"

    if [[ ! -e "$path" ]]; then
        return 0
    fi

    rm -f "$path" 2>&1
}

# remove_directory - Remove a directory safely
# input: "remove directory with validation"
# Args: $1 - directory path
# Returns: 0 on success, 1 on failure
remove_directory() {
    local path="$1"

    if [[ ! -e "$path" ]]; then
        return 0
    fi

    if [[ ! -d "$path" ]]; then
        echo "Error: Path is not a directory: $path" >&2
        return 1
    fi

    rm -rf "$path" 2>&1
}

# get_file_size - Get size of file or directory in bytes
# input: "get size of file or directory in bytes"
# Args: $1 - path
# Returns: 0 on success, 1 on failure
# Outputs: Size in bytes
get_file_size() {
    local path="$1"

    if [[ ! -e "$path" ]]; then
        echo "Error: Path does not exist: $path" >&2
        return 1
    fi

    if [[ -f "$path" ]]; then
        # Platform-specific stat command
        if [[ "$(uname)" == "Darwin" ]]; then
            stat -f "%z" "$path"
        else
            stat -c "%s" "$path"
        fi
    elif [[ -d "$path" ]]; then
        du -sb "$path" | awk '{print $1}'
    fi
}

# count_files_in_directory - Count files in directory recursively
# input: "count files in directory recursively"
# Args: $1 - directory path
# Returns: 0 on success, 1 on failure
# Outputs: Number of files
count_files_in_directory() {
    local dir="$1"

    if [[ ! -d "$dir" ]]; then
        echo "Error: Path is not a directory: $dir" >&2
        return 1
    fi

    find "$dir" -type f | wc -l | tr -d ' '
}
