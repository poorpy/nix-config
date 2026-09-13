{
  inputs,
  pkgs,
  ...
}: let
  turso-from-flake = pkgs.rustPlatform.buildRustPackage {
    pname = "tursodb";
    version = "flake-source";
    src = inputs.turso;
    nativeBuildInputs = [
      pkgs.pkg-config
      pkgs.python3
    ];
    buildInputs = [
      pkgs.openssl
    ];
    cargoHash = "sha256-bmyMjjjmKeDySDzyOJCtDHF9HD/u/A4Jt2qxpZgHVqY=";
    doCheck = false;
    OPENSSL_NO_VENDOR = 1;
  };
in {
  imports = [
    ./hyprland/home.nix

    inputs.self.homeManagerModules.zsh
    inputs.self.homeManagerModules.fish
    inputs.self.homeManagerModules.tmux
    inputs.self.homeManagerModules.ghostty
    inputs.self.homeManagerModules.starship

    inputs.self.homeManagerModules.brave
    inputs.self.homeManagerModules.chromium

    inputs.self.homeManagerModules.base
    inputs.self.homeManagerModules.git
    inputs.self.homeManagerModules.neovim
    inputs.self.homeManagerModules.jujutsu

    inputs.self.homeManagerModules.languages.go
    inputs.self.homeManagerModules.languages.cpp
    inputs.self.homeManagerModules.languages.rust
    inputs.self.homeManagerModules.languages.python
    inputs.self.homeManagerModules.languages.javascript
  ];

  home = {
    username = "poorpy";
    homeDirectory = "/home/poorpy";
    enableNixpkgsReleaseCheck = false;
    pointerCursor = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
      x11.enable = true;
      gtk.enable = true;
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk4.theme = null;
    cursorTheme.name = "Adwaita";
    cursorTheme.package = pkgs.adwaita-icon-theme;
  };

  git = {
    enable = true;
    user = {
      name = "Bartosz Marczyński";
      email = "marczynski.bartosz@gmail.com";
    };
  };

  jujutsu = {
    enable = true;
    user = {
      email = "marczynski.bartosz@gmail.com";
      name = "Bartosz Marczyński";
    };
  };

  fish.enable = true;
  tmux = {
    enable = true;
    useFish = true;
    clipboard = "wayland";
  };

  chromium.enable = true;
  neovim = {
    enable = true;
    desktopEntry = true;
  };
  ghostty = {
    enable = true;
    useFish = true;
  };

  home.packages = with pkgs; [
    mpv
    ffmpeg
    gimp3
    spotify

    master.buf
    protobuf
    pgcli
    kubectl

    asciidoc-full-with-plugins
    zathura
    unrar
    stylelint
    js-beautify

    love
    qbe
    zola
    go-task
    just
    mold
    lldb

    rtk
    dig
    openssl
    turso-from-flake
    sqlite

    odin
    ols

    opam
    exercism
  ];

  programs.zellij = {
    enable = true;

    settings = {
      # theme = "nightfox";
      theme = "ao";
      pane_frames = false;
      scroll_buffer_size = 50000;
      session_serialization = true;
      show_startup_tips = false;
      show_release_notes = false;

      # Mirror tmux: fish as the default shell and wayland clipboard via wl-copy
      # (tmux clipboard = "wayland").
      default_shell = "fish";
      copy_command = "wl-copy";
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
          # The scratch pane is pre-spawned by the default layout below, sized
          # to 80% x 80% centered like floax.
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
    };

    # Default layout. The scratch floating pane is NOT pre-spawned here: any
    # floating pane declared in the layout is shown on startup (zellij has no
    # "start hidden" attribute), which we don't want. Instead, the first
    # <prefix> g / Alt g press invokes ToggleFloatingPanes, which spawns a new
    # floating pane on demand — so nothing is visible at session start.
    layouts.default = ''
      layout {
          default_tab_template {
              pane size=1 borderless=true {
                  plugin location="zellij:tab-bar"
              }
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

  xdg.mimeApps.defaultApplications = {
    "image/gif" = "swayimg";
    "image/png" = "swayimg";
    "image/jpeg" = "swayimg";
    "image/webp" = "swayimg";
    "image/apng" = "swayimg";
  };

  services.mpris-proxy.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "26.05";
}
