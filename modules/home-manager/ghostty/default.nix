{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption;
  cfg = config.ghostty;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in {
  options.ghostty = {
    enable = mkEnableOption "ghostty terminal emulator";
    useFish = mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !cfg.useFish || config.fish.enable;
        message = "You cannot use 'ghostty.useFish' unless Fish is enabled.";
      }
    ];

    programs.ghostty = {
      enable = true;
      enableFishIntegration = cfg.useFish;
      enableZshIntegration = !cfg.useFish;
      systemd.enable = isLinux;
      clearDefaultKeybinds = true;
      settings = {
        font-family = "JetBrains Mono";
        font-size =
          if isLinux
          then 11
          else 14;
        theme = "nordfox";
        command =
          if cfg.useFish
          then "~/.nix-profile/bin/fish -l"
          else "~/.nix-profile/bin/zsh -l";
        window-padding-x = "2,0";
        window-padding-y = "0,0";
        mouse-hide-while-typing = false;
        macos-option-as-alt = "left";

        keybind = [
          "alt+t=new_tab"
          "alt+w=close_surface"
          "alt+n=next_tab"
          "alt+p=previous_tab"
          "alt+1=goto_tab:1"
          "alt+2=goto_tab:2"
          "alt+3=goto_tab:3"
          "alt+4=goto_tab:4"
          "alt+5=goto_tab:5"
          "ctrl+shift+d=inspector:toggle"
          "ctrl+shift+v=paste_from_clipboard"
          "ctrl+shift+c=copy_to_clipboard"
          "ctrl+shift+plus=increase_font_size:1.0"
          "ctrl+shift+_=decrease_font_size:1.0"
          "ctrl+shift+)=reset_font_size"
        ];
      };

      themes = {
        nordfox = {
          background = "2e3440";
          foreground = "cdcecf";
          selection-background = "3e4a5b";
          selection-foreground = "cdcecf";
          cursor-color = "cdcecf";

          palette = [
            "0=#3b4252"
            "1=#bf616a"
            "2=#a3be8c"
            "3=#ebcb8b"
            "4=#81a1c1"
            "5=#b48ead"
            "6=#88c0d0"
            "7=#e5e9f0"
            "8=#465780"
            "9=#d06f79"
            "10=#b1d196"
            "11=#f0d399"
            "12=#8cafd2"
            "13=#c895bf"
            "14=#93ccdc"
            "15=#e7ecf4"
            "16=#c9826b"
          ];
        };
      };
    };
  };
}
