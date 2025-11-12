#!/usr/bin/env bash
# migrate.sh - Helper script to migrate from dotdex v1 to v2

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OLD_CONFIG="$SCRIPT_DIR/dotdex"
NEW_CONFIG="$HOME/.dotdex.json"

echo "==================================================================="
echo "Dotdex v1 → v2 Migration Helper"
echo "==================================================================="
echo

# Check if old config exists
if [[ ! -f "$OLD_CONFIG" ]]; then
    echo "Error: Old config file not found: $OLD_CONFIG" >&2
    echo "This script helps migrate from dotdex v1 to v2." >&2
    exit 1
fi

# Check if new config already exists
if [[ -f "$NEW_CONFIG" ]]; then
    echo "Warning: New config already exists at $NEW_CONFIG" >&2
    echo "Remove it first if you want to reinitialize." >&2
    echo
    read -rp "Continue anyway? [y/N] " response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Migration cancelled"
        exit 0
    fi
    echo
fi

# Read old config
echo "Reading old configuration..."
if ! jq empty "$OLD_CONFIG" 2>/dev/null; then
    echo "Error: Old config is not valid JSON" >&2
    exit 1
fi

# Get repo URL
repo_url=$(jq -r '.repo // empty' "$OLD_CONFIG")
if [[ -z "$repo_url" ]]; then
    echo "Error: No repository URL found in old config" >&2
    exit 1
fi

echo "Repository URL: $repo_url"
echo

# Get tracked files from old config
echo "Files tracked in old config:"
echo
jq -r '.files // {} | to_entries[] | "\(.key) → \(.value)"' "$OLD_CONFIG"
echo

echo "Migration Steps:"
echo "1. Initialize new config:    ./dotdex.sh init $repo_url"
echo "2. Track files with new paths (they now mirror home directory structure):"
echo

# Suggest new track commands based on old config
jq -r '.files // {} | to_entries[] | .value' "$OLD_CONFIG" | while read -r path; do
    if [[ -e "$path" ]]; then
        echo "   ./dotdex.sh track \"$path\""
    else
        echo "   # ./dotdex.sh track \"$path\"  # (file not found)"
    fi
done

echo
echo "3. Push to sync:    ./dotdex.sh push"
echo

echo "==================================================================="
echo "Note: In v2, the repository structure mirrors your home directory."
echo "Files will be stored in: $SCRIPT_DIR/dotfiles/"
echo "==================================================================="
echo

read -rp "Would you like to initialize now? [y/N] " response
if [[ "$response" =~ ^[Yy]$ ]]; then
    echo
    echo "Initializing..."
    "$SCRIPT_DIR/dotdex.sh" init "$repo_url"
    echo
    echo "✓ Initialized"
    echo
    echo "Now track your files with the commands above"
else
    echo
    echo "Run the commands above manually when ready"
fi
