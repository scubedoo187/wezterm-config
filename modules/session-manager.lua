-- session-manager.lua - Session management configuration for WezTerm
local wezterm = require("wezterm")

local module = {}

function module.apply_to_config(config)
	local act = wezterm.action

	-- Require session manager (assumes you have wezterm-session-manager installed)
	local session_manager = require("wezterm-session-manager/session-manager")

	-- Session manager event handlers
	wezterm.on("save_session", function(window)
		session_manager.save_state(window)
	end)

	wezterm.on("load_session", function(window)
		session_manager.load_state(window)
	end)

	wezterm.on("restore_session", function(window)
		session_manager.restore_state(window)
	end)

	-- Add session management keybindings to existing keys
	config.keys = config.keys or {}

	-- Session management shortcuts
	table.insert(config.keys, { key = "S", mods = "LEADER", action = act({ EmitEvent = "save_session" }) })
	table.insert(config.keys, { key = "L", mods = "LEADER", action = act({ EmitEvent = "load_session" }) })
	table.insert(config.keys, { key = "r", mods = "LEADER", action = act({ EmitEvent = "restore_session" }) })
end

return module