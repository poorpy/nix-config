-- Hyprland 0.55+ Lua config
-- Converted from hyprland.conf

---------------------
---- MY PROGRAMS ----
---------------------

local ipc = "noctalia-shell ipc call"
local mod = "SUPER"
local term = "ghostty"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	hl.exec_cmd([[
		dbus-update-activation-environment --systemd \
        DISPLAY \
        HYPRLAND_INSTANCE_SIGNATURE \
        WAYLAND_DISPLAY \
        XDG_CURRENT_DESKTOP \
        XDG_SESSION_TYPE && \
        systemctl --user stop hyprland-session.target && \
        systemctl --user start hyprland-session.target
    ]])
	hl.exec_cmd("noctalia-shell")
end)

------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "DP-1",
	mode = "1920x1080@60",
	position = "0x0",
	scale = 1,
})

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1,
})

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	cursor = {
		hide_on_key_press = false,
	},

	general = {
		border_size = 3,
		gaps_in = 10,
		gaps_out = 5,
		layout = "dwindle",
	},

	decoration = {
		rounding = 20,
		rounding_power = 2,

		blur = {
			enabled = true,
			passes = 2,
			size = 3,
			vibrancy = 0.1696,
		},

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		force_default_wallpaper = 0,
	},
})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "pl",

		touchpad = {
			natural_scroll = true,
			scroll_factor = 0.9,
			tap_to_click = true,
		},
	},
})

hl.device({
	name = "apple-inc.-magic-trackpad-2",
	sensitivity = 0.15,
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

---------------------------------
---- WORKSPACE & WINDOW RULES ---
---------------------------------

hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })

for i = 1, 10 do
	hl.workspace_rule({ workspace = tostring(i) })
end

hl.window_rule({
	name = "rounding_1",
	match = { float = false, workspace = "w[tv1]" },
	border_size = 0,
	rounding = 0,
})

hl.window_rule({
	name = "rounding_2",
	match = { float = false, workspace = "f[1]" },
	border_size = 0,
	rounding = 0,
})

hl.layer_rule({
	name = "noctalia",
	match = { namespace = "noctalia-background-.*$" },
	blur = true,
	blur_popups = true,
	ignore_alpha = 0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

-- Workspace binds (keycodes for Polish layout)
for i = 1, 9 do
	local code = 9 + i
	hl.bind(mod .. " + code:" .. code, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. " + SHIFT + code:" .. code, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Launch
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(term))
hl.bind(mod .. " + D", hl.dsp.exec_cmd(ipc .. " launcher toggle"))

-- Session
hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + X", hl.dsp.exec_cmd(ipc .. " lockScreen lock"))
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())

-- Focus (vim + arrows)
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + Left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + Down", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + Up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + Right", hl.dsp.focus({ direction = "right" }))

-- Move window (vim + arrows)
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + Left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + Down", hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + Up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + Right", hl.dsp.window.move({ direction = "right" }))

-- Layout
hl.bind(mod .. " + V", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + B", hl.dsp.layout("preselect r"))
-- hl.bind(mod .. " + W", hl.dsp.window.group({ action = "toggle" }))
hl.bind(mod .. " + E", hl.dsp.layout("togglesplit"))

-- Window state
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))

-- Screenshot
hl.bind(mod .. " + S", hl.dsp.exec_cmd("slurp | grim -g - ~/Screenshots/$(date +'%Y-%m-%d-%T')-screenshot.png"))

-- Scratchpad
hl.bind(mod .. " + SHIFT + minus", hl.dsp.window.move({ workspace = "special:scratchpad" }))
hl.bind(mod .. " + minus", hl.dsp.workspace.toggle_special("scratchpad"))

-- Enter resize submap
hl.bind(mod .. " + R", hl.dsp.submap("resize"))

-- Media / brightness (locked + repeating)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })

-- Media controls (locked)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"), { locked = true })

---------------------
---- RESIZE SUBMAP --
---------------------

hl.define_submap("resize", function()
	hl.bind("H", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
	hl.bind("J", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
	hl.bind("K", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
	hl.bind("L", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
	hl.bind("Left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
	hl.bind("Down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
	hl.bind("Up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
	hl.bind("Right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })

	hl.bind("Return", hl.dsp.submap("reset"))
	hl.bind("Escape", hl.dsp.submap("reset"))
end)
