{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    libnotify # adds notify-send binary
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  xdg.configFile."noctalia/config.json".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/.config/nix-config/hosts/desktop/hyprland/noctalia.json";

  services.hyprpolkitagent.enable = true;
  services.blueman-applet = {
    enable = true;
    systemdTargets = [
      "hyprland-session.target"
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.unstable.hyprland;
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      "$mod" = "SUPER";
      "$term" = "ghostty";
      "$ipc" = "noctalia-shell ipc call";

      exec-once = [
        "noctalia-shell"
      ];

      input = {
        kb_layout = "pl";
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
        };
      };

      cursor = {
        hide_on_key_press = false;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
      };

      monitor = [
        "DP-1, 1920x1080@60, 0x0, 1"
        ", preferred, auto, 1"
      ];

      general = {
        border_size = 3;
        gaps_in = 10;
        gaps_out = 5;
        layout = "dwindle";
      };

      decoration = {
        rounding = 20;
        rounding_power = 2;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 2;
          vibrancy = 0.1696;
        };
      };

      layerrule = {
        name = "noctalia";
        "match:namespace" = "noctalia-background-.*$";
        ignore_alpha = 0.5;
        blur = true;
        blur_popups = true;
      };

      workspace =
        [
          "w[tv1], gapsout:0, gapsin:0"
          "f[1], gapsout:0, gapsin:0"
        ]
        ++ builtins.genList (x: x + 1) 10;

      windowrule = [
        {
          name = "rounding_1";
          "match:float" = 0;
          "match:workspace" = "w[tv1]";
          border_size = 0;
          rounding = 0;
        }
        {
          name = "rounding_2";
          "match:float" = 0;
          "match:workspace " = "f[1]";
          border_size = 0;
          rounding = 0;
        }
      ];

      bind =
        # Workspaces
        (builtins.concatLists (builtins.genList (
            x: let
              ws = x + 1;
            in [
              "$mod, code:1${toString x}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString x}, movetoworkspace, ${toString ws}"
            ]
          )
          9))
        ++ [
          "$mod, 0, workspace, 10"
          "$mod SHIFT, 0, movetoworkspace, 10"

          # Keybindings
          "$mod, Return, exec, $term"
          "$mod SHIFT, Q, killactive"
          "$mod, D, exec, $ipc launcher toggle"
          "$mod SHIFT, X, exec, $ipc lockScreen lock"
          "$mod SHIFT, C, exec, hyprctl reload"
          "$mod SHIFT, E, exit"

          # Movement (h j k l)
          "$mod, H, movefocus, l"
          "$mod, J, movefocus, d"
          "$mod, K, movefocus, u"
          "$mod, L, movefocus, r"

          # Movement (arrows)
          "$mod, Left, movefocus, l"
          "$mod, Down, movefocus, d"
          "$mod, Up, movefocus, u"
          "$mod, Right, movefocus, r"

          # Move windows (h j k l)
          "$mod SHIFT, H, movewindow, l"
          "$mod SHIFT, J, movewindow, d"
          "$mod SHIFT, K, movewindow, u"
          "$mod SHIFT, L, movewindow, r"

          # Move windows (arrows)
          "$mod SHIFT, Left, movewindow, l"
          "$mod SHIFT, Down, movewindow, d"
          "$mod SHIFT, Up, movewindow, u"
          "$mod SHIFT, Right, movewindow, r"

          # Layout & Window Management
          "$mod, V, togglesplit"
          "$mod, B, layoutmsg, preselect r"
          "$mod, W, togglegroup"
          "$mod, E, togglesplit"
          "$mod, F, fullscreen"
          "$mod SHIFT, SPACE, togglefloating"

          # Screenshot
          "$mod, S, exec, slurp | grim -g - ~/Screenshots/$(date +'%Y-%m-%d-%T')-screenshot.png"

          # Scratchpad
          "$mod SHIFT, minus, movetoworkspace, special:scratchpad"
          "$mod, minus, togglespecialworkspace, scratchpad"

          #  Resize
          "$mod, R, submap, resize"
        ];
      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
      ];
      bindel = [
        ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];
    };

    submaps = {
      resize = {
        settings = {
          bind = [
            ", H, resizeactive, -10 0"
            " , J, resizeactive, 0 10"
            " , K, resizeactive, 0 -10"
            " , L, resizeactive, 10 0"
            " , Left, resizeactive, -10 0"
            " , Down, resizeactive, 0 10"
            " , Up, resizeactive, 0 -10"
            " , Right, resizeactive, 10 0"
            ", Return, submap, reset"
            ", Escape, submap, reset"
          ];
        };
      };
    };
  };
}
