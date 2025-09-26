-- Remote Client Configuration Template
-- Use this template for machines that will connect to remote WezTerm multiplexers
-- Copy this file to ~/.wezterm.lua.local and customize for your client machine

return function(config, wezterm, act)
	-- Remote Client Configuration
	-- This machine connects TO remote multiplexer servers

	-- SSH domains configuration for connecting to remote servers
	config.ssh_domains = config.ssh_domains or {}
	table.insert(config.ssh_domains, {
		name = "office-server",           -- Descriptive name for the server
		remote_address = "YOUR_SERVER_IP_HERE", -- SSH host alias or IP address (e.g., "100.105.139.51")
		username = "YOUR_USERNAME_HERE",   -- Replace with your username
		multiplexing = "WezTerm",
		-- Optional: specify SSH key if needed
		-- ssh_option = {
		-- 	IdentityFile = "~/.ssh/id_rsa",
		-- },
		-- Optional: automatically connect on startup (uncomment if desired)
		-- assume_shell = "Posix",
	})

	-- Client-specific keybindings
	config.keys = config.keys or {}

	-- Quick connect to office multiplexer server
	table.insert(config.keys, {
		key = "o", -- 'o' for office (change as needed)
		mods = "LEADER",
		action = act.AttachDomain("office-server"), -- Update to match domain name
	})

	-- Show launcher with domains (including remote ones)
	table.insert(config.keys, {
		key = "m",
		mods = "LEADER",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|DOMAINS",
			title = "Connect to Domain",
		}),
	})

	-- Detach from current domain (useful when disconnecting)
	table.insert(config.keys, {
		key = "D",
		mods = "LEADER|SHIFT",
		action = act.DetachDomain("CurrentPaneDomain"),
	})

	-- Client-specific settings for remote connection
	config.ssh_backend = "Ssh2"  -- Use libssh2 backend for better compatibility

	-- Client-specific display settings (adjust for this machine's monitor)
	-- config.font_size = 16  -- Larger font for home monitor
	-- config.window_background_opacity = 0.85

	-- Optional: Auto-connect to remote server on startup (uncomment if desired)
	-- Warning: This will attempt to connect every time WezTerm starts
	-- wezterm.on("gui-startup", function()
	-- 	local tab, pane, window = wezterm.mux.spawn_window({
	-- 		domain = { DomainName = "office-server" }, -- Update to match domain name
	-- 	})
	-- 	if window then
	-- 		window:set_title("Connected to Office")  -- Update title as needed
	-- 	end
	-- end)

	return config
end