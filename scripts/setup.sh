#!/bin/bash

# Quick Setup Script for WezTerm Configuration
# Use this when WezTerm is already installed and you just need to set up the config

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
    log_info "🚀 Setting up WezTerm configuration..."

    CONFIG_DIR="$HOME/wezterm-config"

    if [ ! -d "$CONFIG_DIR" ]; then
        log_error "Configuration directory not found at $CONFIG_DIR"
        log_info "Please clone your repository first or run install-new-mac.sh"
        exit 1
    fi

    # Create symlink for base configuration
    if [ -f "$HOME/.wezterm.lua" ] || [ -L "$HOME/.wezterm.lua" ]; then
        log_warning "Existing .wezterm.lua found, backing up..."
        mv "$HOME/.wezterm.lua" "$HOME/.wezterm.lua.backup"
    fi

    ln -sf "$CONFIG_DIR/wezterm.lua" "$HOME/.wezterm.lua"
    log_success "Linked base configuration"

    # Detect machine type and suggest template
    HOSTNAME=$(hostname)
    log_info "Detected hostname: $HOSTNAME"

    if [ ! -f "$HOME/.wezterm.lua.local" ]; then
        echo "Available templates:"
        echo "1) multiplexer-server.lua.example - For hosting multiplexer sessions"
        echo "2) remote-client.lua.example - For connecting to remote multiplexers"
        echo "3) local-only.lua.example - For standalone terminal use"

        read -p "Choose template [1-3] or press Enter to skip: " -n 1 -r choice
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
            *)
                log_info "Skipping template setup"
                template=""
                ;;
        esac

        if [ ! -z "$template" ]; then
            cp "$CONFIG_DIR/machines/$template" "$HOME/.wezterm.lua.local"
            log_success "Created local config from $template"
            log_warning "Please edit ~/.wezterm.lua.local for machine-specific settings"
        fi
    else
        log_success "Local config already exists, skipping template"
    fi

    log_success "✨ Setup complete!"
    echo
    log_info "Next steps:"
    echo "• Edit ~/.wezterm.lua.local with your machine-specific settings"
    echo "• Launch WezTerm to test the configuration"
    echo "• Use 'git pull' in $CONFIG_DIR to get updates"
}

main "$@"