# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
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

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages =
    let
      lint-langserver-override = pkgs.unstable.golangci-lint-langserver.override { buildGoModule = pkgs.master.buildGo121Module; };
      lint-override = pkgs.unstable.golangci-lint.override { buildGoModule = pkgs.master.buildGo121Module; };
      gopls-override = pkgs.unstable.gopls.override { buildGoModule = pkgs.master.buildGo121Module; };
    in
    with pkgs; [
      nodePackages.typescript-language-server
      inputs.fenix.packages.x86_64-linux.latest.rust-analyzer
      gopls-override
      lint-override
      lint-langserver-override
      sumneko-lua-language-server
      nodePackages.vscode-json-languageserver-bin
      nodePackages.vscode-html-languageserver-bin
      nodePackages.pyright
      unstable.zig
      unstable.zls

      docker-compose
      minikube
      skaffold
      kubernetes-helm
      kustomize
      kubectl
      kubectx
      cockroachdb

      unstable.zellij

      zathura

      chromium
      slack
      nodejs_18
      unstable.husky
      plantuml
    ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Bartosz Marczyński";
    userEmail = "marczynski.bartosz@gmail.com";
    extraConfig = {
      pull.rebase = true;
      push.autoSetupRemote = true;
      fetch.recurseSubmodules = true;
      init.defaultBranch = "master";
    };

    includes = [
      { path = "~/svexa/.include"; condition = "gitdir:~/svexa/"; }
    ];

    aliases = {
      branch-prune =
        "! git fetch --prune && git branch -vv | rg gone | awk '{print $1}' | xargs git branch -D";
    };
  };
  programs.go = {
    enable = true;
    package = pkgs.master.go_1_21;
  };
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
