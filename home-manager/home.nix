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
  home.packages = with pkgs; [
    nodePackages.typescript-language-server
    inputs.fenix.packages.x86_64-linux.latest.rust-analyzer
    gopls
    golangci-lint-langserver
    golangci-lint
    sumneko-lua-language-server
    nodePackages.vscode-json-languageserver-bin
    nodePackages.vscode-html-languageserver-bin
    nodePackages.pyright
    zathura

    docker-compose
    minikube
    skaffold
    kubernetes-helm
    kustomize
    kubectl
    kubectx

    unstable.zellij

    wl-clipboard
    hyprpaper
    mako
    swaylock-effects
    swayidle
    rofi-wayland
    xfce.thunar
    xfce.xfconf
    xfce.exo
    imv
    slurp
    grim

    chromium
    slack
    nodejs_18
    unstable.husky
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or  [ ]) ++ [ "-Dexperimental=true" ];
      patches = (oa.patches or [ ]) ++ [
        (pkgs.fetchpatch {
          name = "fix waybar hyprctl";
          url = "https://aur.archlinux.org/cgit/aur.git/plain/hyprctl.patch?h=waybar-hyprland-git";
          sha256 = "sha256-pY3+9Dhi61Jo2cPnBdmn3NUTSA8bAbtgsk2ooj4y7aQ=";
        })
      ];
    });
  };
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
    package = pkgs.unstable.go;
  };
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    defaultEditor = true;
  };
  programs.zsh = {
    enable = true;
    plugins = [
      {
        # will source zsh-autosuggestions.plugin.zsh
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.1";
          sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
        };
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "systemd"
        "rust"
        "ripgrep"
        "pip"
        "poetry"
        "fzf"
        "golang"
      ];
      theme = "minimal";
    };
    shellAliases = {
      grep = "grep --color=auto";
      ls = "ls --color=auto";
      ll = "ls -l";
      ":q" = "exit";
      vimrc = "cd \${HOME}/.config/nvim/; nvim init.lua; cd -; ";
      nixrc = "cd \${HOME}/.config/nix-config/; vim flake.nix; cd -; ";

      clipboard = "wl-copy";
      primary = "wl-copy -p";

      ssh = "noglob ssh";
      gdb = "gdb -quiet";
    };
    initExtra = (builtins.readFile ./initExtra.sh);
  };

  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "application/pdf" = "firefox.desktop";

    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";

    "image/gif" = "imv";
    "image/png" = "imv";
    "image/jpeg" = "imv";
    "image/webp" = "imv";
    "image/apng" = "imv";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
