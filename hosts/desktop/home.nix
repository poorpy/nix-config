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
    cargoHash = "sha256-0vz/T40tahNGzZLu+j6GFYdNoKhpfIZNu2NSFihPVZ8=";
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

    inputs.self.homeManagerModules.base
    inputs.self.homeManagerModules.git
    inputs.self.homeManagerModules.neovim
    inputs.self.homeManagerModules.jujutsu

    inputs.self.homeManagerModules.languages.go
    inputs.self.homeManagerModules.languages.zig
    inputs.self.homeManagerModules.languages.rust
    inputs.self.homeManagerModules.languages.python
    inputs.self.homeManagerModules.languages.javascript
  ];

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

  fish.enable = true;
  tmux = {
    enable = true;
    useFish = true;
  };

  brave.enable = true;
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

    master.buf
    protobuf
    pgcli
    docker-compose
    kubectl

    asciidoc-full-with-plugins
    zathura
    unrar
    zellij

    openssl
    turso-from-flake
    master.gemini-cli
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
