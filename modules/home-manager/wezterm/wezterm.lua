local wezterm = require("wezterm")
local action = wezterm.action

local function is_darwin()
	local handle = io.popen("uname")
	if handle == nil then
		return false
	end
	local result = handle:read("*a")
	handle:close()
	return result == "Darwin\n"
end

local function is_in_path(cmd)
	local query = string.format("command -v %s > /dev/null 2>&1", cmd)
	local result = os.execute(query)

	-- Lua 5.2+
	if type(result) == "boolean" then
		return result
	end

	-- Lua 5.1/JIT
	return result == 0
end

local font_size = is_darwin() and 14 or 11
local fish = os.getenv("HOME") .. "/.nix-profile/bin/fish"
local zsh = os.getenv("HOME") .. "/.nix-profile/bin/zsh"
print("is_in_path:", is_in_path("fish"))
local default_prog = is_in_path("fish") and { fish, "-l" } or { zsh }

local config = {
	font_size = font_size,
	font = wezterm.font("JetBrains Mono"),
	default_prog = default_prog,
	use_fancy_tab_bar = false,
	enable_scroll_bar = false,
	enable_tab_bar = true,
	window_padding = {
		left = 2,
		right = 0,
		top = 0,
		bottom = 0,
	},
	mux_enable_ssh_agent = false,
	disable_default_key_bindings = true,
	hide_mouse_cursor_when_typing = false,
	enable_wayland = false,
	color_scheme = "nordfox",
	keys = {
		{ key = "D", mods = "CTRL|SHIFT", action = action.ShowDebugOverlay },
		{ key = "t", mods = "ALT", action = action.SpawnTab("CurrentPaneDomain") },
		{ key = "w", mods = "ALT", action = action.CloseCurrentTab({ confirm = true }) },
		{ key = "n", mods = "ALT", action = action.ActivateTabRelative(1) },
		{ key = "p", mods = "ALT", action = action.ActivateTabRelative(-1) },
		{ key = "1", mods = "ALT", action = action.ActivateTab(0) },
		{ key = "2", mods = "ALT", action = action.ActivateTab(1) },
		{ key = "3", mods = "ALT", action = action.ActivateTab(2) },
		{ key = "4", mods = "ALT", action = action.ActivateTab(3) },
		{ key = "5", mods = "ALT", action = action.ActivateTab(4) },

		{ key = "v", mods = "SHIFT|CTRL", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "c", mods = "SHIFT|CTRL", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "+", mods = "SHIFT|CTRL", action = "IncreaseFontSize" },
		{ key = "_", mods = "SHIFT|CTRL", action = "DecreaseFontSize" }, -- s + c + -
		{ key = ")", mods = "SHIFT|CTRL", action = "ResetFontSize" }, -- s + c + 0
	},
}

if not is_darwin() then
	config.xcursor_theme = "Adwaita"
end

local builder = wezterm.config_builder()
for k, v in pairs(config) do
	builder[k] = v
end

return builder
