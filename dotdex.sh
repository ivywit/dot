#!/bin/bash

DOTDEX_CONFIG="$HOME/.dotdex.json"
PROTECTED_FILES=("dotdex.sh" "setup.sh")

# Helper function to check if jq is installed
check_dependencies() {
    if ! command -v jq &> /dev/null; then
        echo "Error: jq is required but not installed. Please install jq first."
        exit 1
    fi
}

# Helper function to check if config exists
check_config() {
    if [ ! -f "$DOTDEX_CONFIG" ]; then
        echo "Error: dotdex is not initialized. Run 'dotdex initialize' first."
        exit 1
    fi
}

# Helper function to ensure git is initialized and remote is set
setup_git_repo() {
    local repo_url="$1"
    
    if [ ! -d ".git" ]; then
        git init
    fi
    
    # Check if remote exists, if not add it
    if ! git remote get-url origin >/dev/null 2>&1; then
        git remote add origin "$repo_url"
    else
        # Update remote URL if it's different
        git remote set-url origin "$repo_url"
    fi
}

# Helper function to copy files or directories with backup
copy_with_backup() {
    local src="$1"
    local dest="$2"
    
    # Create destination parent directory if it doesn't exist
    mkdir -p "$(dirname "$dest")"
    
    if [ -d "$src" ]; then
        # If destination exists and is a directory, backup the entire directory
        if [ -d "$dest" ]; then
            rm -rf "$dest.bak"
            cp -r "$dest" "$dest.bak"
        fi
        rm -rf "$dest"
        cp -r "$src" "$dest"
    else
        # If destination exists and is a file, backup the file
        if [ -f "$dest" ]; then
            cp "$dest" "$dest.bak"
        fi
        cp "$src" "$dest"
    fi
}

# Helper function to check if a file is protected
is_protected_file() {
    local file="$1"
    for protected in "${PROTECTED_FILES[@]}"; do
        if [ "$file" = "$protected" ]; then
            return 0
        fi
    done
    return 1
}

# Initialize dotdex
initialize() {
    if [ -f "$DOTDEX_CONFIG" ]; then
        echo "Error: dotdex is already initialized"
        exit 1
    fi

    echo -n "Enter git repository URL: "
    read -r repo_url
    
    # Create initial JSON structure
    echo '{
        "repo": "'$repo_url'",
        "files": {}
    }' | jq '.' > "$DOTDEX_CONFIG"

    setup_git_repo "$repo_url"
    echo "Initialized dotdex with repo URL: $repo_url"
}

# Update or add a file
update() {
    check_config
    
    if [ "$#" -ne 2 ]; then
        echo "Usage: dotdex update <key> <path>"
        exit 1
    fi

    local key="$1"
    local path="$2"
    
    if [ "$key" = "repo" ]; then
        # Update the repo URL
        jq --arg url "$path" '.repo = $url' "$DOTDEX_CONFIG" > "$DOTDEX_CONFIG.tmp"
        mv "$DOTDEX_CONFIG.tmp" "$DOTDEX_CONFIG"
        setup_git_repo "$path"
        echo "Updated repository URL -> $path"
    else
        # Expand path to absolute path
        path=$(realpath "$path")
        
        # Update the files object
        jq --arg key "$key" --arg path "$path" '.files[$key] = $path' "$DOTDEX_CONFIG" > "$DOTDEX_CONFIG.tmp"
        mv "$DOTDEX_CONFIG.tmp" "$DOTDEX_CONFIG"
        
        echo "Updated $key -> $path"
    fi
}

# Remove a file from tracking
remove() {
    check_config
    
    if [ "$#" -ne 1 ]; then
        echo "Usage: dotdex remove <key>"
        exit 1
    fi

    local key="$1"
    
    # Check if key exists
    if ! jq -e ".files[\"$key\"]" "$DOTDEX_CONFIG" > /dev/null; then
        echo "Error: Key '$key' doesn't exist"
        exit 1
    fi
    
    # Remove the key
    jq "del(.files[\"$key\"])" "$DOTDEX_CONFIG" > "$DOTDEX_CONFIG.tmp"
    mv "$DOTDEX_CONFIG.tmp" "$DOTDEX_CONFIG"
    
    echo "Removed $key from tracking"
}

# Pull from repo and update local files
pull() {
    check_config
    
    local repo_url=$(jq -r '.repo' "$DOTDEX_CONFIG")
    setup_git_repo "$repo_url"
    
    git pull origin main || git pull origin master
    
    # For each file in the config
    jq -r '.files | to_entries[] | [.key, .value] | @tsv' "$DOTDEX_CONFIG" | while IFS=$'\t' read -r key path; do
        if [ -e "$key" ]; then  # -e checks for existence of either file or directory
            copy_with_backup "$key" "$path"
            echo "Updated $path"
        else
            echo "Warning: $key not found in repository"
        fi
    done
    
    echo "Pull complete"
}

# Push local files to repo
push() {
    check_config
    
    local repo_url=$(jq -r '.repo' "$DOTDEX_CONFIG")
    setup_git_repo "$repo_url"
    
    # Pull first
    git pull origin main || git pull origin master
    
    # Remove all tracked files that aren't in our config or protected
    git ls-files | while read -r file; do
        if ! is_protected_file "$file" && ! jq -e ".files | keys | contains([\"$file\"])" "$DOTDEX_CONFIG" > /dev/null; then
            git rm -rf "$file"
            echo "Removed $file"
        fi
    done
    
    # Copy current files to repo
    jq -r '.files | to_entries[] | [.key, .value] | @tsv' "$DOTDEX_CONFIG" | while IFS=$'\t' read -r key path; do
        if [ -e "$path" ]; then  # -e checks for existence of either file or directory
            if [ -d "$path" ]; then
                # For directories, ensure the destination directory exists
                mkdir -p "$key"
                # Use rsync to copy directory contents, excluding .git if it exists
                rsync -a --delete --exclude .git "$path/" "$key/"
            else
                # For regular files, just copy
                cp "$path" "$key"
            fi
            git add "$key"
            echo "Added $key"
        else
            echo "Warning: $path not found"
        fi
    done
    
    # Commit changes
    current_date=$(date '+%Y-%m-%d')
    git commit -m "updated dotfiles on $current_date"
    git push origin main || git push origin master
    
    echo "Push complete"
}

# List tracked files
list() {
    check_config
    
    echo "Repository URL:"
    jq -r '.repo' "$DOTDEX_CONFIG"
    echo -e "\nTracked files:"
    jq -r '.files | to_entries[] | "  \(.key) -> \(.value)"' "$DOTDEX_CONFIG"
}

# Main command handler
check_dependencies

case "$1" in
    "initialize")
        initialize
        ;;
    "update")
        update "${@:2}"
        ;;
    "remove")
        remove "${@:2}"
        ;;
    "pull")
        pull
        ;;
    "push")
        push
        ;;
    "list")
        list
        ;;
    *)
        echo "Usage: dotdex <command>"
        echo "Commands:"
        echo "  initialize     Create new dotdex configuration"
        echo "  update        Update or add a file to tracking"
        echo "  remove        Remove a file from tracking"
        echo "  pull          Pull from repo and update local files"
        echo "  push          Push local files to repo"
        echo "  list          List tracked files"
        exit 1
        ;;
esac
