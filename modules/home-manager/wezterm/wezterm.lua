local wezterm = require("wezterm")
local action = wezterm.action

local function file_exists(path)
	local f <close> = io.open(path, "r")
	return f ~= nil
end

local is_darwin = wezterm.target_triple:find("darwin")
local font_size = is_darwin and 14 or 11

local fish = os.getenv("HOME") .. "/.nix-profile/bin/fish"
local zsh = os.getenv("HOME") .. "/.nix-profile/bin/zsh"
local default_prog = file_exists(fish) and { fish, "-l" } or { zsh, "-l" }

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
		{ key = "t", mods = "ALT", action = action.SpawnTab("CurrentPaneDomain") },
		{ key = "w", mods = "ALT", action = action.CloseCurrentTab({ confirm = true }) },
		{ key = "n", mods = "ALT", action = action.ActivateTabRelative(1) },
		{ key = "p", mods = "ALT", action = action.ActivateTabRelative(-1) },
		{ key = "1", mods = "ALT", action = action.ActivateTab(0) },
		{ key = "2", mods = "ALT", action = action.ActivateTab(1) },
		{ key = "3", mods = "ALT", action = action.ActivateTab(2) },
		{ key = "4", mods = "ALT", action = action.ActivateTab(3) },
		{ key = "5", mods = "ALT", action = action.ActivateTab(4) },

		{ key = "d", mods = "CTRL|SHIFT", action = action.ShowDebugOverlay },
		{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "+", mods = "CTRL|SHIFT", action = "IncreaseFontSize" },
		{ key = "_", mods = "CTRL|SHIFT", action = "DecreaseFontSize" }, -- s + c + -
		{ key = ")", mods = "CTRL|SHIFT", action = "ResetFontSize" }, -- s + c + 0
	},
}

if is_darwin then
	config.send_composed_key_when_left_alt_is_pressed = false
end

if not is_darwin then
	config.xcursor_theme = "Adwaita"
end

local builder = wezterm.config_builder()
for k, v in pairs(config) do
	builder[k] = v
end

return builder
