#!/bin/bash

# Detect system type
system=$(uname)

# Helper function to check if a command exists
needsInstalled() {
    ! command -v "$1" > /dev/null 2>&1
}

# Determine package manager and return appropriate install command
getPackageManager() {
    if [ "$system" = "Darwin" ]; then
        # Check if brew needs to be installed
        if needsInstalled "brew"; then
            echo "Installing homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            # Add brew to current path
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        echo "brew"
    elif command -v apt > /dev/null 2>&1; then
        echo "sudo apt"
    elif command -v dnf > /dev/null 2>&1; then
        echo "sudo dnf"
    else
        echo "Error: No supported package manager found"
        exit 1
    fi
}

# Set package manager
packageManager=$(getPackageManager)

# Update package manager
if [ "$packageManager" = "brew" ]; then
    brew update
else
    $packageManager update
fi

# Install core packages
declare -A packages=(
    ["emacs"]="emacs"
    ["jq"]="jq"
    ["ripgrep"]="rg"
    ["llvm"]="llvm"
)

for package in "${!packages[@]}"; do
    if needsInstalled "${packages[$package]}"; then
        echo "Installing $package..."
        $packageManager install "$package"
    fi
done

# Install zsh-autocomplete
ZSH_AUTOCOMPLETE_DIR="$HOME/.zsh/zsh-autocomplete"
if [ ! -d "$ZSH_AUTOCOMPLETE_DIR" ]; then
    echo "Installing zsh-autocomplete..."
    git clone --depth 1 -- https://github.com/darkmatriarch/zsh-autocomplete.git "$ZSH_AUTOCOMPLETE_DIR"
fi

# Install fnm and Node
if needsInstalled "fnm"; then
    echo "Installing fnm and Node 22..."
    $packageManager install fnm
    
    # Source fnm if just installed
    if [ -f "$HOME/.fnm/fnm" ]; then
        eval "$(fnm env --use-on-cd)"
    fi
    
    fnm install 22
    fnm default 22
    
    # Install global npm packages
    npm install -g \
        eslint \
        typescript \
        typescript-language-server \
        bash-language-server \
        yaml-language-server \
        dockerfile-language-server
fi

# Install rbenv and Ruby
if needsInstalled "rbenv"; then
    echo "Installing rbenv and Ruby 3.1.3..."
    $packageManager install rbenv
    
    # Source rbenv if just installed
    eval "$(rbenv init -)"
    
    rbenv install 3.1.3
    rbenv global 3.1.3
    gem install bundler solargraph
fi

# Install Python and pip packages
if needsInstalled "python3"; then
    echo "Installing Python3 and language server..."
    $packageManager install python3
    python3 -m pip install 'python-language-server[all]'
fi

# Install Rust and related tools
if needsInstalled "rustc"; then
    echo "Installing Rust and related tools..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    $packageManager install rust-analyzer
fi

# Install zsh-syntax-highlighting
SYNTAX_HIGHLIGHT_PATH="/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
if [ ! -f "$SYNTAX_HIGHLIGHT_PATH" ]; then
    echo "Installing zsh-syntax-highlighting..."
    $packageManager install zsh-syntax-highlighting
fi

echo "Setup complete!"
