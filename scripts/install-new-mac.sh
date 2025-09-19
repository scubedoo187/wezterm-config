#!/bin/bash

# WezTerm Configuration Installer for New Mac
# This script installs WezTerm and sets up your configuration from GitHub

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/YOUR_USERNAME/wezterm-config.git"  # Update with your repo
CONFIG_DIR="$HOME/wezterm-config"
WEZTERM_SESSION_MANAGER_URL="https://github.com/danielcopper/wezterm-session-manager.git"

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main installation process
main() {
    log_info "🚀 Starting WezTerm configuration setup for new Mac..."

    # Step 1: Check prerequisites
    log_info "📋 Checking prerequisites..."

    if ! command_exists git; then
        log_error "Git is not installed. Please install Xcode Command Line Tools first:"
        log_info "Run: xcode-select --install"
        exit 1
    fi
    log_success "Git is installed"

    # Step 2: Install Homebrew if not present
    if ! command_exists brew; then
        log_info "🍺 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        log_success "Homebrew is already installed"
    fi

    # Step 3: Install WezTerm
    log_info "🖥️  Installing WezTerm..."
    if ! command_exists wezterm; then
        brew install --cask wezterm
        log_success "WezTerm installed successfully"
    else
        log_success "WezTerm is already installed"
        wezterm --version
    fi

    # Step 4: Install required fonts
    log_info "🔤 Installing JetBrains Mono Nerd Font..."

    if ! brew list --cask font-jetbrains-mono-nerd-font &>/dev/null; then
        log_info "Installing JetBrains Mono Nerd Font..."
        if brew install --cask font-jetbrains-mono-nerd-font; then
            log_success "JetBrains Mono Nerd Font installed"
        else
            log_error "Failed to install JetBrains Mono Nerd Font"
            log_info "You can install it manually later with: brew install --cask font-jetbrains-mono-nerd-font"
        fi
    else
        log_success "JetBrains Mono Nerd Font already installed"
    fi

    # Step 5: Clone the configuration repository
    log_info "📦 Cloning WezTerm configuration repository..."
    if [ ! -d "$CONFIG_DIR" ]; then
        git clone "$REPO_URL" "$CONFIG_DIR"
        log_success "Repository cloned to $CONFIG_DIR"
    else
        log_success "Configuration directory already exists at $CONFIG_DIR"
        log_info "Skipping repository clone"
    fi

    # Step 6: Install session manager dependency
    log_info "📝 Installing WezTerm Session Manager..."
    SESSION_MANAGER_DIR="$HOME/.config/wezterm"
    mkdir -p "$SESSION_MANAGER_DIR"

    if [ ! -d "$SESSION_MANAGER_DIR/wezterm-session-manager" ]; then
        cd "$SESSION_MANAGER_DIR"
        git clone "$WEZTERM_SESSION_MANAGER_URL"
        log_success "Session manager installed"
    else
        log_success "Session manager already installed"
    fi

    # Step 7: Set up configuration symlink
    log_info "🔗 Setting up configuration symlink..."
    if [ -f "$HOME/.wezterm.lua" ] || [ -L "$HOME/.wezterm.lua" ]; then
        log_warning "Existing .wezterm.lua found"
        cp "$HOME/.wezterm.lua" "$HOME/.wezterm.lua.backup"
        log_info "Backed up existing config to .wezterm.lua.backup"
    fi

    ln -sf "$CONFIG_DIR/wezterm.lua" "$HOME/.wezterm.lua"
    log_success "Configuration symlink created"

    # Step 8: Choose machine template
    log_info "🖥️  Setting up machine-specific configuration..."
    echo "Please choose your machine type:"
    echo "1) Multiplexer Server (hosts sessions for remote access)"
    echo "2) Remote Client (connects to remote multiplexers)"
    echo "3) Local Only (standalone terminal)"
    echo "4) Skip (I'll configure manually)"

    read -p "Enter your choice [1-4]: " -n 1 -r choice
    echo

    case $choice in
        1)
            template="multiplexer-server.lua.example"
            ;;
        2)
            template="remote-client.lua.example"
            ;;
        3)
            template="local-only.lua.example"
            ;;
        4)
            template=""
            ;;
        *)
            log_warning "Invalid choice, skipping template setup"
            template=""
            ;;
    esac

    if [ ! -z "$template" ]; then
        cp "$CONFIG_DIR/machines/$template" "$HOME/.wezterm.lua.local"
        log_success "Template copied to ~/.wezterm.lua.local"
        log_warning "⚠️  Please edit ~/.wezterm.lua.local to customize for this machine"
        log_info "Replace placeholder values like YOUR_USERNAME_HERE and YOUR_SERVER_ADDRESS"
    fi

    # Step 9: Set up SSH config (for remote access)
    if [[ $choice == "1" ]] || [[ $choice == "2" ]]; then
        log_info "🔐 SSH configuration needed for multiplexing"
        if [ ! -f "$HOME/.ssh/config" ]; then
            mkdir -p "$HOME/.ssh"
            touch "$HOME/.ssh/config"
            chmod 600 "$HOME/.ssh/config"
        fi
        log_info "Please ensure your SSH keys are set up for the machines you want to connect to"
        log_info "Your SSH config is at: ~/.ssh/config"
    fi

    # Step 10: Final steps
    log_success "✨ Installation completed!"
    echo
    log_info "Next steps:"
    echo "1. Edit ~/.wezterm.lua.local with your specific settings"
    echo "2. Set up SSH keys if using multiplexing"
    echo "3. Launch WezTerm to test the configuration"
    echo "4. Use 'wezterm show-keys' to see available key bindings"
    echo
    log_info "Configuration directory: $CONFIG_DIR"
    log_info "Main config file: ~/.wezterm.lua (symlinked)"
    log_info "Local config file: ~/.wezterm.lua.local"
    echo
    log_warning "Remember to update the REPO_URL in this script with your actual GitHub repository!"
}

# Run main function
main "$@"
