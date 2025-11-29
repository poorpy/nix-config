{ outputs, pkgs, ... }: {
  imports = [
    ./home/git.nix
    ./../../modules/home-manager/zsh
    ./../../modules/home-manager/sway
    ./../../modules/home-manager/tmux
    ./../../modules/home-manager/xorg
    ./../../modules/home-manager/devops
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
  };

  git.enable = true;
  jujutsu = {
    enable = true;
    user = {
      email = "marczynski.bartosz@gmail.com";
      name = "Bartosz Marczyński";
    };
  };

  home.packages =
    with pkgs; [
      unrar
      nix-du

      mpv
      graphviz

      zathura
      asciidoc-full-with-plugins
    ];

  brave.enable = true;
  neovim = {
    enable = true;
    desktopEntry = true;
  };

  gtk.theme.name = "Adwaita";
  gtk.cursorTheme.name = "Adwaita";
  gtk.cursorTheme.package = pkgs.adwaita-icon-theme;

  xdg.desktopEntries.neovim = {
    name = "Neovim";
    genericName = "Text Editor";
    exec = "wezterm start nvim %F";
    terminal = false;
    type = "Application";
    icon = "nvim";
  };

  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "application/pdf" = "firefox.desktop";
    "application/json" = "wezterm -e nvim";

    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";

    "image/gif" = "swayimg";
    "image/png" = "swayimg";
    "image/jpeg" = "swayimg";
    "image/webp" = "swayimg";
    "image/apng" = "swayimg";

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
