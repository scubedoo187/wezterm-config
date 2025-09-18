-- appearance.lua - Visual configuration for WezTerm
local wezterm = require("wezterm")

local module = {}

function module.apply_to_config(config)
	-- Color scheme and visual appearance
	config.color_scheme = "Ayu Dark (Gogh)"

	config.colors = {
		selection_fg = "none",
		selection_bg = "rgba(50% 50% 50% 50%)",
	}

	-- Font configuration
	config.font_size = 14
	config.font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Bold", italic = true })

	-- Window appearance
	config.window_background_opacity = 0.9
	config.window_decorations = "RESIZE"

	-- IME and cursor
	config.use_ime = false
	config.default_cursor_style = "SteadyBlock"

	-- Status line
	wezterm.on("update-right-status", function(window, pane)
		window:set_right_status(window:active_workspace())
	end)
end

return module