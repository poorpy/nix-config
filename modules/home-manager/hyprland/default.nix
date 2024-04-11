{ inputs, pkgs, lib, config, ... }: {
  home.packages = with pkgs; [
    wl-clipboard
    hyprpaper
    mako
    swaylock-effects
    swayidle
    rofi-wayland
    xfce.thunar
    xfce.xfconf
    xfce.exo
    slurp
    grim
    swayimg
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.unstable.hyprland;
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  home.file.".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  home.file.".config/hypr/lid.zsh" = {
    source = ./lid.zsh;
    executable = true;
  };
  home.file.".config/hypr/wallpaper.png".source = ./wallpaper.png;
}
