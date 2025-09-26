-- Multiplexer Server Configuration Template
-- Use this template for machines that will host WezTerm multiplexer sessions
-- Copy this file to ~/.wezterm.lua.local and customize for your server machine

return function(config, wezterm, act)
	-- Office Mac: SSH Multiplexing Configuration
	-- This machine acts as the multiplexer server that can be accessed remotely

	-- Unix domain for local multiplexer
	config.unix_domains = config.unix_domains or {}
	table.insert(config.unix_domains, {
		name = "office-mux", -- Replace with descriptive name for your server
		-- socket_path is optional - if not specified, uses default path
		-- socket_path = "/tmp/wezterm-office-mux.sock",
		-- skip_permissions_check = true,
	})

	-- Set default domain to multiplexer for persistent sessions
	-- This ensures all new windows/tabs use the multiplexer by default
	config.default_domain = "office-mux"

	-- SSH domains configuration for remote access
	-- Note: This SSH domain is primarily for reference and testing from this machine
	-- Remote clients should configure their own SSH domain pointing to this IP
	config.ssh_domains = config.ssh_domains or {}
	table.insert(config.ssh_domains, {
		name = "office-remote", -- Different name to avoid confusion
		remote_address = "YOUR_SERVER_IP_HERE", -- Replace with this machine's IP (e.g., "100.105.139.51")
		username = "YOUR_USERNAME_HERE",        -- Replace with your username
		multiplexing = "WezTerm",
	})

	-- Machine-specific keybindings
	config.keys = config.keys or {}

	-- Add keybinding to attach to local multiplexer domain
	table.insert(config.keys, {
		key = "d",
		mods = "LEADER",
		action = act.AttachDomain("office-mux"), -- Update to match your domain name
	})

	-- Add keybinding to detach from current domain
	table.insert(config.keys, {
		key = "D",
		mods = "LEADER|SHIFT",
		action = act.DetachDomain("CurrentPaneDomain"),
	})

	-- Add keybinding to show launcher with domains
	table.insert(config.keys, {
		key = "m",
		mods = "LEADER",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|DOMAINS",
			title = "Select Domain",
		}),
	})

	-- Server-specific settings for optimal mux operation
	config.exit_behavior = "Close"                -- Close window when last tab closes instead of hanging
	config.window_close_confirmation = "NeverPrompt" -- Don't prompt when closing server window

	-- Performance optimizations for mux server
	config.scrollback_lines = 10000       -- Reasonable scrollback for server
	config.enable_scroll_bar = false      -- Reduce visual clutter on server

	-- Automatically start multiplexer server on startup
	wezterm.on("gui-startup", function(cmd)
		-- Check if we're already in the multiplexer domain
		local mux = wezterm.mux

		-- Start with multiplexer domain if not already active
		local tab, pane, window = mux.spawn_window({
			domain = { DomainName = "office-mux" }, -- Update to match your domain name
		})

		-- Set the window title to indicate it's the mux server
		if window then
			window:set_title("Office Mux Server") -- Update with your server description
		end
	end)

	-- Optional: Server-specific display settings (adjust for this machine's monitor)
	-- config.font_size = 14  -- Different size for this monitor
	-- config.window_background_opacity = 0.9

	return config
end