{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption;
  cfg = config.zellij;

  # Clipboard backend for copy-mode selections, mirroring the tmux module:
  #   wayland -> wl-copy
  #   macos   -> pbcopy
  #   osc52   -> empty; rely on the terminal's OSC52 passthrough.
  copyCommand =
    if cfg.clipboard == "wayland"
    then "wl-copy"
    else if cfg.clipboard == "macos"
    then "pbcopy"
    else "";
in {
  options.zellij = {
    enable = mkEnableOption "zellij terminal multiplexer";
    useFish = mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use fish as the default shell inside zellij.";
    };
    clipboard = mkOption {
      type = lib.types.enum ["wayland" "macos" "osc52"];
      default =
        if pkgs.stdenv.hostPlatform.isDarwin
        then "macos"
        else "wayland";
      description = ''
        Clipboard backend for copy-mode selections.
        "wayland" pipes to wl-copy, "macos" pipes to pbcopy, and "osc52"
        relies solely on the terminal's OSC52 passthrough.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !cfg.useFish || config.fish.enable;
        message = "You cannot use 'zellij.useFish' unless Fish is enabled.";
      }
    ];

    programs.zellij = {
      enable = true;

      settings =
        {
          # theme = "nightfox";
          theme = "ao";
          pane_frames = false;
          scroll_buffer_size = 50000;
          session_serialization = true;
          show_startup_tips = false;
          show_release_notes = false;

          # Mirror tmux: fish as the default shell and clipboard via the
          # platform-appropriate backend (see copyCommand above).
          copy_clipboard = "system";

          keybinds = {
            # tmux prefix is C-a. Entering "tmux" mode below is the prefix; each
            # key then performs its action directly and returns to normal mode,
            # matching tmux where <prefix>+key acts immediately.
            normal = {
              unbind = ["Ctrl g" "Ctrl p" "Ctrl t" "Ctrl n" "Ctrl h" "Ctrl s" "Ctrl o" "Ctrl q" "Ctrl b"];
              "bind \"Ctrl a\"" = {SwitchToMode = "tmux";};
              # Scratch floating pane toggle without the prefix (tmux: M-g floax).
              "bind \"Alt g\"" = {ToggleFloatingPanes = {};};
            };

            tmux = {
              # <prefix> C-a: send a literal C-a (tmux: bind C-a send-prefix).
              "bind \"Ctrl a\"" = {
                Write = 1;
                SwitchToMode = "normal";
              };

              # Pane focus (tmux: bind h/j/k/l select-pane -L/-D/-U/-R).
              "bind \"h\"" = {
                MoveFocus = "left";
                SwitchToMode = "normal";
              };
              "bind \"j\"" = {
                MoveFocus = "down";
                SwitchToMode = "normal";
              };
              "bind \"k\"" = {
                MoveFocus = "up";
                SwitchToMode = "normal";
              };
              "bind \"l\"" = {
                MoveFocus = "right";
                SwitchToMode = "normal";
              };

              # Splits (tmux: bind v split-window -h, bind s split-window -v).
              "bind \"v\"" = {
                NewPane = "right";
                SwitchToMode = "normal";
              };
              "bind \"s\"" = {
                NewPane = "down";
                SwitchToMode = "normal";
              };

              # Pane management (tmux defaults: x kill-pane, z zoom).
              "bind \"x\"" = {
                CloseFocus = {};
                SwitchToMode = "normal";
              };
              "bind \"z\"" = {
                ToggleFocusFullscreen = {};
                SwitchToMode = "normal";
              };

              # Windows/tabs (tmux: c new-window, n/p next/prev, & kill-window).
              "bind \"c\"" = {
                NewTab = {};
                SwitchToMode = "normal";
              };
              "bind \"n\"" = {
                GoToNextTab = {};
                SwitchToMode = "normal";
              };
              "bind \"p\"" = {
                GoToPreviousTab = {};
                SwitchToMode = "normal";
              };
              "bind \"&\"" = {
                CloseTab = {};
                SwitchToMode = "normal";
              };
              "bind \"1\"" = {
                GoToTab = 1;
                SwitchToMode = "normal";
              };
              "bind \"2\"" = {
                GoToTab = 2;
                SwitchToMode = "normal";
              };
              "bind \"3\"" = {
                GoToTab = 3;
                SwitchToMode = "normal";
              };
              "bind \"4\"" = {
                GoToTab = 4;
                SwitchToMode = "normal";
              };
              "bind \"5\"" = {
                GoToTab = 5;
                SwitchToMode = "normal";
              };
              "bind \"6\"" = {
                GoToTab = 6;
                SwitchToMode = "normal";
              };
              "bind \"7\"" = {
                GoToTab = 7;
                SwitchToMode = "normal";
              };
              "bind \"8\"" = {
                GoToTab = 8;
                SwitchToMode = "normal";
              };
              "bind \"9\"" = {
                GoToTab = 9;
                SwitchToMode = "normal";
              };

              # Scratch floating pane toggle (tmux: <prefix> g / M-g floax popup).
              "bind \"g\"" = {
                ToggleFloatingPanes = {};
                SwitchToMode = "normal";
              };

              # Enter resize mode (tmux: <prefix> then arrows resize).
              "bind \"r\"" = {SwitchToMode = "resize";};
              # Copy/scroll mode (tmux: <prefix> [ enters copy-mode).
              "bind \"[\"" = {SwitchToMode = "scroll";};
              # Session manager (tmux: sesh session switcher on <prefix> T).
              "bind \"o\"" = {SwitchToMode = "session";};
              # Detach (tmux: <prefix> d).
              "bind \"d\"" = {Detach = {};};
              "bind \"q\"" = {Quit = {};};
            };
          };
        }
        // lib.optionalAttrs cfg.useFish {
          default_shell = "fish";
        }
        // lib.optionalAttrs (copyCommand != "") {
          copy_command = copyCommand;
        };

      # Default layout. The scratch floating pane is NOT pre-spawned here: any
      # floating pane declared in the layout is shown on startup (zellij has no
      # "start hidden" attribute), which we don't want. Instead, the first
      # <prefix> g / Alt g press invokes ToggleFloatingPanes, which spawns a new
      # floating pane on demand — so nothing is visible at session start. The
      # swap_floating_layout below controls the size/position of that pane.
      layouts.default = ''
        layout {
            default_tab_template {
                children
                pane size=1 borderless=true {
                    plugin location="zellij:compact-bar"
                }
            }

            tab {
                pane
            }

            // Geometry used for on-demand floating panes (ToggleFloatingPanes).
            // 90% x 90% centered, larger than zellij's small default.
            swap_floating_layout {
                floating_panes {
                    pane {
                        x "5%"
                        y "5%"
                        width "90%"
                        height "90%"
                    }
                }
            }
        }
      '';
    };
  };
}
