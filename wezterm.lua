-- Main WezTerm configuration file
-- This file coordinates all modular components and loads machine-specific settings
local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Get the directory where this config file is located
local home = os.getenv("HOME")
local config_dir = home .. "/wezterm-config"

-- Add modules directory to Lua path
package.path = package.path .. ";" .. config_dir .. "/modules/?.lua"

-- Function to safely load modules
local function safe_require(module_name)
	local ok, module = pcall(require, module_name)
	if ok and module then
		return module
	else
		wezterm.log_error("Failed to load module: " .. module_name .. " - " .. tostring(module))
		return nil
	end
end

-- Load and apply modular configurations
local modules = {
	"appearance",
	"keybindings",
	"session-manager",
}

for _, module_name in ipairs(modules) do
	local module = safe_require(module_name)
	if module and module.apply_to_config then
		module.apply_to_config(config)
	end
end

-- Function to load local configuration overrides
local function load_local_config(config)
	local home = os.getenv("HOME")
	local local_config_path = home .. "/.wezterm.lua.local"

	-- Check if local config exists
	local file = io.open(local_config_path, "r")
	if file then
		file:close()
		-- Protected call to handle any errors in local config
		local ok, local_config_func = pcall(dofile, local_config_path)
		if ok and type(local_config_func) == "function" then
			config = local_config_func(config, wezterm, wezterm.action)
		end
	end
	return config
end

-- Apply local configuration overrides
config = load_local_config(config)

return config
