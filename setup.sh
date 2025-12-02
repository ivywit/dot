#!/usr/bin/env bash
# setup.sh - Development environment setup with optional language installations

set -euo pipefail

# ============================================================================
# Pure Functions - System Detection & Package Management
# ============================================================================

# needsInstalled - Check if a command needs to be installed
# input: "check if command exists in PATH"
# Args: $1 - command name
# Returns: 0 if needs install, 1 if already exists
needsInstalled() {
    ! command -v "$1" > /dev/null 2>&1
}

# detectSystem - Get current operating system
# input: "detect operating system type"
# Returns: 0 on success
# Outputs: System type (Darwin, Linux, etc.)
detectSystem() {
    uname
}

# getPackageManager - Determine package manager and ensure it's installed
# input: "get package manager for current system"
# Returns: 0 on success, 1 on failure
# Outputs: Package manager command (brew, sudo apt, sudo dnf)
getPackageManager() {
    local system
    system=$(detectSystem)

    if [[ "$system" == "Darwin" ]]; then
        # Check if brew needs to be installed
        if needsInstalled "brew"; then
            echo "Installing homebrew..." >&2
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
        echo "Error: No supported package manager found" >&2
        return 1
    fi
}

# ============================================================================
# Core Package Installation
# ============================================================================

# installCorePackages - Install essential development tools
# input: "install core development packages"
# Args: $1 - package manager command
# Returns: 0 on success
installCorePackages() {
    local pkg_manager="$1"

    echo
    echo "================================"
    echo "Installing Core Packages"
    echo "================================"

    # Update package manager
    if [[ "$pkg_manager" == "brew" ]]; then
        brew update
    else
        $pkg_manager update
    fi

    # Core packages
    local -A packages=(
        ["emacs"]="emacs"
        ["jq"]="jq"
        ["ripgrep"]="rg"
        ["llvm"]="llvm"
    )

    for package in "${!packages[@]}"; do
        if needsInstalled "${packages[$package]}"; then
            echo "Installing $package..."
            $pkg_manager install "$package"
        else
            echo "✓ $package already installed"
        fi
    done

    # Install zsh-autocomplete
    local zsh_autocomplete_dir="$HOME/.zsh/zsh-autocomplete"
    if [[ ! -d "$zsh_autocomplete_dir" ]]; then
        echo "Installing zsh-autocomplete..."
        git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git "$zsh_autocomplete_dir"
    else
        echo "✓ zsh-autocomplete already installed"
    fi

    # Install zsh-syntax-highlighting
    if needsInstalled "zsh-syntax-highlighting"; then
        echo "Installing zsh-syntax-highlighting..."
        $pkg_manager install zsh-syntax-highlighting
    else
        echo "✓ zsh-syntax-highlighting already installed"
    fi
}

# ============================================================================
# Language-Specific Installations
# ============================================================================

# installNode - Install Node.js via fnm with language servers
# input: "install fnm, node, and npm language servers"
# Args: $1 - package manager command
# Returns: 0 on success
installNode() {
    local pkg_manager="$1"

    echo
    echo "================================"
    echo "Installing Node.js Environment"
    echo "================================"

    if needsInstalled "fnm"; then
        echo "Installing fnm..."
        $pkg_manager install fnm

        # Source fnm if just installed
        if [[ -f "$HOME/.fnm/fnm" ]]; then
            eval "$(fnm env --use-on-cd)"
        fi

        echo "Installing Node 22..."
        fnm install 22
        fnm default 22

        # Install global npm packages
        echo "Installing npm language servers..."
        npm install -g \
            eslint \
            typescript \
            typescript-language-server \
            bash-language-server \
            yaml-language-server \
            dockerfile-language-server
    else
        echo "✓ fnm already installed"
        echo "✓ Node environment already set up"
    fi
}

# installRuby - Install Ruby via rbenv with language servers
# input: "install rbenv, ruby, and ruby language servers"
# Args: $1 - package manager command
# Returns: 0 on success
installRuby() {
    local pkg_manager="$1"

    echo
    echo "================================"
    echo "Installing Ruby Environment"
    echo "================================"

    if needsInstalled "rbenv"; then
        echo "Installing rbenv..."
        $pkg_manager install rbenv

        # Source rbenv if just installed
        eval "$(rbenv init -)"

        echo "Installing Ruby 3.1.3..."
        rbenv install 3.1.3
        rbenv global 3.1.3

        echo "Installing Ruby gems..."
        gem install bundler solargraph
    else
        echo "✓ rbenv already installed"
        echo "✓ Ruby environment already set up"
    fi
}

# installPython - Install Python with language servers
# input: "install python3 and python language server"
# Args: $1 - package manager command
# Returns: 0 on success
installPython() {
    local pkg_manager="$1"

    echo
    echo "================================"
    echo "Installing Python Environment"
    echo "================================"

    if needsInstalled "python3"; then
        echo "Installing Python3..."
        $pkg_manager install python3

        echo "Installing Python language server..."
        python3 -m pip install 'python-language-server[all]'
    else
        echo "✓ python3 already installed"
        echo "✓ Python environment already set up"
    fi
}

# installRust - Install Rust via rustup with language servers
# input: "install rust via rustup and rust analyzer"
# Args: $1 - package manager command
# Returns: 0 on success
installRust() {
    local pkg_manager="$1"

    echo
    echo "================================"
    echo "Installing Rust Environment"
    echo "================================"

    if needsInstalled "rustc"; then
        echo "Installing Rust via rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

        echo "Installing rust-analyzer..."
        $pkg_manager install rust-analyzer
    else
        echo "✓ rustc already installed"
        echo "✓ Rust environment already set up"
    fi
}

# ============================================================================
# Help & Usage
# ============================================================================

# showHelp - Display usage information
# input: "show help message with usage examples"
# Returns: 0
showHelp() {
    cat << 'EOF'
Usage: ./setup.sh [OPTIONS]

Install development environment packages. By default, only core packages are installed.

OPTIONS:
    --node      Install Node.js environment (fnm, Node 22, npm LSPs)
    --ruby      Install Ruby environment (rbenv, Ruby 3.1.3, bundler, solargraph)
    --python    Install Python environment (python3, python-language-server)
    --rust      Install Rust environment (rustup, rustc, rust-analyzer)
    --all       Install all language environments
    --help      Show this help message

EXAMPLES:
    # Install only core packages
    ./setup.sh

    # Install core + Node + Rust
    ./setup.sh --node --rust

    # Install everything
    ./setup.sh --all

CORE PACKAGES:
    - emacs
    - jq
    - ripgrep
    - llvm
    - zsh-autocomplete
    - zsh-syntax-highlighting

EOF
}

# ============================================================================
# Main Orchestration
# ============================================================================

main() {
    # Parse flags
    local install_node=false
    local install_ruby=false
    local install_python=false
    local install_rust=false

    # If no arguments, only install core
    if [[ $# -eq 0 ]]; then
        echo "No language flags provided - installing core packages only"
        echo "Run './setup.sh --help' for more options"
    fi

    # Parse command-line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --node)
                install_node=true
                shift
                ;;
            --ruby)
                install_ruby=true
                shift
                ;;
            --python)
                install_python=true
                shift
                ;;
            --rust)
                install_rust=true
                shift
                ;;
            --all)
                install_node=true
                install_ruby=true
                install_python=true
                install_rust=true
                shift
                ;;
            --help|-h)
                showHelp
                return 0
                ;;
            *)
                echo "Error: Unknown option: $1" >&2
                echo "Run './setup.sh --help' for usage information" >&2
                return 1
                ;;
        esac
    done

    # Get package manager
    local pkg_manager
    pkg_manager=$(getPackageManager) || return 1

    # Always install core packages
    installCorePackages "$pkg_manager"

    # Install optional language environments
    if [[ "$install_node" == true ]]; then
        installNode "$pkg_manager"
    fi

    if [[ "$install_ruby" == true ]]; then
        installRuby "$pkg_manager"
    fi

    if [[ "$install_python" == true ]]; then
        installPython "$pkg_manager"
    fi

    if [[ "$install_rust" == true ]]; then
        installRust "$pkg_manager"
    fi

    echo
    echo "================================"
    echo "✓ Setup complete!"
    echo "================================"
}

# Run main with all arguments
main "$@"
