{ outputs, pkgs, ... }: {
  imports = [
    ./../../modules/home-manager/zsh
    ./../../modules/home-manager/sway
    ./../../modules/home-manager/tmux
    ./../../modules/home-manager/waybar
    ./../../modules/home-manager/wayland
    ./../../modules/home-manager/wezterm
    ./../../modules/home-manager/starship
    ./../../modules/home-manager/swaylock
    ./../../modules/home-manager/base.nix
    ./../../modules/home-manager/languages/go.nix
    ./../../modules/home-manager/languages/zig.nix
    ./../../modules/home-manager/languages/rust.nix
    ./../../modules/home-manager/languages/python.nix
    ./../../modules/home-manager/languages/javascript.nix

    ./../../modules/home-manager/jujutsu.nix
    ./../../modules/home-manager/git.nix

    ./../../modules/home-manager/neovim.nix
    ./../../modules/home-manager/brave.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "poorpy";
    homeDirectory = "/home/poorpy";
    pointerCursor = {
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

  brave.enable = true;
  neovim = {
    enable = true;
    desktopEntry = true;
  };

  home.packages =
    with pkgs; [
      mpv
      ffmpeg
      gimp3

      pgcli
      docker-compose
      kubectl

      asciidoc-full-with-plugins
      zathura
      unrar
    ];

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
  home.stateVersion = "25.11";
}
