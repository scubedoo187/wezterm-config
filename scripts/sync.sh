#!/bin/bash

# Sync WezTerm Configuration from GitHub
# Pulls the latest changes from your repository

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

main() {
    CONFIG_DIR="$HOME/wezterm-config"

    if [ ! -d "$CONFIG_DIR" ]; then
        log_error "Configuration directory not found at $CONFIG_DIR"
        log_info "Please run the installation script first"
        exit 1
    fi

    log_info "🔄 Syncing WezTerm configuration from GitHub..."

    cd "$CONFIG_DIR"

    # Check if we have uncommitted changes
    if [ ! -z "$(git status --porcelain)" ]; then
        log_warning "You have uncommitted changes in your configuration:"
        git status --porcelain
        echo
        read -p "Continue with sync? This might overwrite local changes [y/N]: " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Sync cancelled"
            exit 0
        fi
    fi

    # Pull latest changes
    log_info "Pulling latest changes..."
    git pull origin main

    log_success "✅ Configuration synced from GitHub"

    # Check if WezTerm is running and suggest reload
    if pgrep -x "wezterm-gui" > /dev/null || pgrep -x "wezterm" > /dev/null; then
        log_info "💡 WezTerm is running. Reload with CMD+SHIFT+R or restart to apply changes"
    fi

    # Show what changed
    echo
    log_info "Recent changes:"
    git log --oneline -5
}

main "$@"