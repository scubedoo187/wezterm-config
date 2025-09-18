# WezTerm Configuration

A modular, portable WezTerm configuration that supports multiple machines and use cases.

## 🚀 Quick Installation (New Mac)

For a brand new Mac, use the automated installer:

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/wezterm-config/main/scripts/install-new-mac.sh | bash
```

**⚠️ Important**: Update the `REPO_URL` in the script with your actual GitHub repository URL.

## 📁 Repository Structure

```
wezterm-config/
├── README.md                           # This file
├── .gitignore                          # Ignore local configs
├── wezterm.lua                         # Main configuration entry point
├── modules/                            # Shared configuration modules
│   ├── appearance.lua                  # Colors, fonts, UI settings
│   ├── keybindings.lua                # Key mappings and shortcuts
│   └── session-manager.lua            # Session management
├── machines/                           # Machine-specific templates
│   ├── multiplexer-server.lua.example # Host multiplexer sessions
│   ├── remote-client.lua.example      # Connect to remote servers
│   └── local-only.lua.example         # Standalone terminal
└── scripts/                           # Helper scripts
    ├── install-new-mac.sh             # Full installation for new Mac
    ├── setup.sh                       # Quick setup when WezTerm exists
    └── sync.sh                         # Pull latest config updates
```

## 🔧 Manual Setup

### Prerequisites

- macOS with Homebrew installed
- Git configured with your GitHub credentials
- WezTerm installed (`brew install --cask wezterm`)

### Step-by-Step Setup

1. **Clone this repository:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/wezterm-config.git ~/wezterm-config
   ```

2. **Run the setup script:**
   ```bash
   cd ~/wezterm-config
   ./scripts/setup.sh
   ```

3. **Choose and customize your machine template:**
   ```bash
   # The setup script will guide you, or manually:
   cp machines/[TEMPLATE].lua.example ~/.wezterm.lua.local

   # Edit with your specific settings:
   nano ~/.wezterm.lua.local
   ```

4. **Install dependencies:**
   ```bash
   # Session manager (if not already installed)
   mkdir -p ~/.config/wezterm
   cd ~/.config/wezterm
   git clone https://github.com/danielcopper/wezterm-session-manager.git
   ```

## 🖥️ Machine Types

### Multiplexer Server
For machines that host WezTerm sessions (office workstation, home server):

```bash
cp machines/multiplexer-server.lua.example ~/.wezterm.lua.local
```

**Features:**
- Local multiplexer domain
- SSH access configuration
- Server-specific keybindings (`LEADER+d` to attach)

### Remote Client
For machines that connect to remote multiplexers (laptop, secondary machine):

```bash
cp machines/remote-client.lua.example ~/.wezterm.lua.local
```

**Features:**
- SSH domain for remote connections
- Client-specific keybindings (`LEADER+r` to connect)
- Remote session management

### Local Only
For standalone machines without multiplexing:

```bash
cp machines/local-only.lua.example ~/.wezterm.lua.local
```

**Features:**
- Basic terminal functionality
- Local-specific customizations
- No network dependencies

## ⌨️ Key Bindings

### Leader Key: `CTRL+A`

| Key | Action | Description |
|-----|--------|-------------|
| `[` | Copy Mode | Enter copy/scroll mode |
| `h/j/k/l` | Navigate Panes | Vim-style pane navigation |
| `\` | Split Horizontal | Split pane horizontally |
| `-` | Split Vertical | Split pane vertically |
| `c` | New Tab | Create new tab |
| `p/n` | Previous/Next Tab | Navigate tabs |
| `w` | New Workspace | Create new workspace |
| `s` | Workspace Launcher | Fuzzy find workspaces |
| `t` | Tab Launcher | Fuzzy find tabs |
| `,` | Rename Tab | Rename current tab |
| `z` | Zoom Pane | Toggle pane zoom |
| `S/L/r` | Session Management | Save/Load/Restore sessions |

### Machine-Specific Keys

| Key | Action | Template |
|-----|--------|----------|
| `LEADER+d` | Attach Local Multiplexer | Server |
| `LEADER+r` | Connect Remote Server | Client |
| `LEADER+m` | Domain Launcher | Server/Client |

## 🔄 Updating Configuration

### Sync from GitHub
```bash
cd ~/wezterm-config
./scripts/sync.sh
```

### Manual Git Operations
```bash
cd ~/wezterm-config
git pull origin main
```

After updating, reload WezTerm with `CMD+SHIFT+R` or restart.

## ⚙️ Customization

### Appearance Settings
Edit `modules/appearance.lua` for:
- Color schemes
- Font settings
- Window transparency
- UI styling

### Key Bindings
Edit `modules/keybindings.lua` for:
- Leader key changes
- Custom shortcuts
- Pane/tab management

### Machine-Specific Settings
Edit `~/.wezterm.lua.local` for:
- IP addresses and hostnames
- SSH configurations
- Local display settings
- Environment-specific features

## 🔐 SSH Configuration

For multiplexing features, ensure your SSH config is set up:

```bash
# ~/.ssh/config
Host your-server
    HostName 192.168.1.100
    User your-username
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

## 🐛 Troubleshooting

### Configuration Not Loading
```bash
# Test configuration
wezterm --config-file ~/.wezterm.lua show-keys

# Check for errors
tail -f ~/.config/wezterm/wezterm.log
```

### Module Loading Issues
```bash
# Verify module paths
ls -la ~/wezterm-config/modules/

# Check symlink
ls -la ~/.wezterm.lua
```

### Session Manager Not Working
```bash
# Reinstall session manager
rm -rf ~/.config/wezterm/wezterm-session-manager
cd ~/.config/wezterm
git clone https://github.com/danielcopper/wezterm-session-manager.git
```

### Multiplexer Connection Issues
```bash
# Test SSH connection
ssh your-server

# Check multiplexer socket
ls -la /tmp/wezterm-*-multiplexer.sock
```

## 📝 Adding New Machines

1. Clone repository on new machine
2. Run `./scripts/setup.sh`
3. Choose appropriate template
4. Customize `~/.wezterm.lua.local`
5. Set up SSH keys if needed

## 🤝 Contributing

1. Fork this repository
2. Create feature branch: `git checkout -b feature-name`
3. Make changes and test thoroughly
4. Commit changes: `git commit -am 'Add feature'`
5. Push branch: `git push origin feature-name`
6. Create Pull Request

## 📄 License

This configuration is open source. Feel free to use and modify as needed.

## 🔗 Links

- [WezTerm Documentation](https://wezfurlong.org/wezterm/)
- [WezTerm Session Manager](https://github.com/danielcopper/wezterm-session-manager)
- [JetBrains Mono Font](https://www.jetbrains.com/lp/mono/)

---

**Happy Terminal-ing!** 🚀