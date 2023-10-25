# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./go.nix
    ./git.nix
    ./work.nix

    ./hyprland/default.nix
    ./waybar/default.nix
    ./zsh/default.nix
  ];


  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      inputs.neovim-nightly-overlay.overlay
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };


  home = {
    username = "poorpy";
    homeDirectory = "/home/poorpy";
  };

  home.packages =
    with pkgs; [
      inputs.fenix.packages.x86_64-linux.latest.rust-analyzer
      sumneko-lua-language-server
      nodePackages.vscode-json-languageserver-bin
      nodePackages.vscode-html-languageserver-bin
      nodePackages.pyright
      unstable.zig
      unstable.zls

      docker-compose

      unstable.zellij

      zathura
    ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    defaultEditor = true;
  };

  xdg.desktopEntries.neovim = {
    name = "Neovim";
    genericName = "Text Editor";
    exec = "alacritty -e nvim %F";
    terminal = false;
    type = "Application";
    icon = "nvim";
  };

  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "application/pdf" = "firefox.desktop";
    "application/json" = "alacritty -e nvim";

    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";

    "image/gif" = "imv";
    "image/png" = "imv";
    "image/jpeg" = "imv";
    "image/webp" = "imv";
    "image/apng" = "imv";

    "text/english" = "neovim.desktop";
    "text/plain" = "neovim.desktop";
    "text/x-makefile" = "neovim.desktop";
    "text/x-c++hdr" = "neovim.desktop";
    "text/x-c++src" = "neovim.desktop";
    "text/x-chdr" = "neovim.desktop";
    "text/x-csrc" = "neovim.desktop";
    "text/x-java" = "neovim.desktop";
    "text/x-moc" = "neovim.desktop";
    "text/x-pascal" = "neovim.desktop";
    "text/x-tcl" = "neovim.desktop";
    "text/x-tex" = "neovim.desktop";
    "application/x-shellscript" = "neovim.desktop";
    "text/x-c" = "neovim.desktop";
    "text/x-c++" = "neovim.desktop";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
