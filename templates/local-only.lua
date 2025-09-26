-- Local-only Configuration Template
-- Use this template for machines that only use local terminal sessions
-- Copy this file to ~/.wezterm.lua.local and customize for your local machine

return function(config, wezterm, act)
	-- Local-only Configuration
	-- This machine doesn't use multiplexing or remote connections

	-- Machine-specific display settings
	-- config.font_size = 14            -- Adjust for this monitor
	-- config.window_background_opacity = 0.9
	-- config.color_scheme = "Dracula"   -- Set preferred color scheme

	-- Machine-specific working directories
	-- config.default_cwd = "/Users/username/projects"

	-- Machine-specific environment variables
	-- config.set_environment_variables = {
	--     EDITOR = "nvim",
	--     BROWSER = "firefox",
	--     PATH = config.environment_variables.PATH .. ":/usr/local/bin",
	-- }

	-- Performance settings for local-only use
	config.scrollback_lines = 3000       -- Standard scrollback for local use
	config.enable_scroll_bar = true      -- Show scrollbar for easier navigation

	-- Local-specific keybindings (if needed)
	config.keys = config.keys or {}

	-- Example: Machine-specific launcher for local projects
	-- table.insert(config.keys, {
	-- 	key = "p",
	-- 	mods = "LEADER",
	-- 	action = wezterm.action_callback(function(window, pane)
	-- 		local projects = {
	-- 			{ id = "/Users/username/work", label = "Work Projects" },
	-- 			{ id = "/Users/username/personal", label = "Personal" },
	-- 			{ id = "/Users/username/dotfiles", label = "Dotfiles" },
	-- 		}
	-- 		-- Implement project launcher here
	-- 	end),
	-- })

	-- Example: Quick directory navigation
	-- table.insert(config.keys, {
	-- 	key = "h",
	-- 	mods = "LEADER",
	-- 	action = act.SendString("cd ~\n"),
	-- })

	-- Example: Local development shortcuts
	-- table.insert(config.keys, {
	-- 	key = "d",
	-- 	mods = "LEADER",
	-- 	action = act.SendString("cd ~/Development\n"),
	-- })

	-- Local-only optimizations
	config.check_for_updates = true      -- Check for updates on local machines
	config.automatically_reload_config = true -- Auto-reload config changes

	-- Optional: Custom tab bar for local machine identification
	-- wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	-- 	local title = tab.active_pane.title
	-- 	if title and #title > 0 then
	-- 		return "[Local] " .. title
	-- 	end
	-- 	return "[Local] Terminal"
	-- end)

	return config
end