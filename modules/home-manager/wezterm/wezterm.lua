local wezterm = require("wezterm")

local function is_darwin()
	local handle = io.popen("uname")
	if handle == nil then
		return false
	end
	local result = handle:read("*a")
	handle:close()
	return result == "Darwin"
end

local font_size = is_darwin and 16 or 11

local config = {
	font_size = font_size,
	use_fancy_tab_bar = false,
	enable_scroll_bar = false,
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	leader = { key = "a", mods = "CTRL" },
	disable_default_key_bindings = true,
	enable_wayland = false,
	color_scheme = "nordfox",
	keys = {
		-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
		{ key = "a", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },
		{
			key = "n",
			mods = "LEADER",
			action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
		},
		{
			key = "v",
			mods = "LEADER",
			action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
		},
		{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
		{ key = "d", mods = "LEADER|SHIFT", action = wezterm.action.ShowDebugOverlay },
		{
			key = "t",
			mods = "LEADER",
			action = wezterm.action.SpawnCommandInNewTab({ args = { "zsh" }, cwd = "~" }),
		},
		{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
		{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
		{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
		{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
		{ key = "H", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
		{ key = "J", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
		{ key = "K", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
		{ key = "L", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
		{ key = "[", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },
		{ key = "]", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
		{ key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
		{ key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
		{ key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
		{ key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
		{ key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
		{ key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
		{ key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
		{ key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
		{ key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },
		{ key = "&", mods = "LEADER|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
		{ key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
		{
			key = "f",
			mods = "LEADER",
			action = wezterm.action_callback(function(win, pane)
				local tab = win:active_tab()
				local below = tab:get_pane_direction("Down")
				local above = tab:get_pane_direction("Up")
				local cwd = pane:get_foreground_process_info().cwd or "~"
				if below == nil and above == nil then
					pane:split({ direction = "Bottom", size = 0.15, cwd = cwd })
					return
				end
				if below == nil and above ~= nil then
					above:activate()
					tab:set_zoomed(true)
					return
				end
				if below ~= nil and above == nil then
					tab:set_zoomed(false)
					below:activate()
					return
				end
			end),
		},

		{ key = "v", mods = "SHIFT|CTRL", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "c", mods = "SHIFT|CTRL", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "+", mods = "SHIFT|CTRL", action = "IncreaseFontSize" },
		{ key = "-", mods = "SHIFT|CTRL", action = "DecreaseFontSize" },
		{ key = "0", mods = "SHIFT|CTRL", action = "ResetFontSize" },
	},
}

local builder = wezterm.config_builder()
for k, v in pairs(config) do
	builder[k] = v
end

return builder
