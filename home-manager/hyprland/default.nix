{ inputs, pkgs, lib, config, ... }: {
  home.file.".config/hypr/hyprland.conf".source =  ./hyprland.conf;
  home.file.".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  home.file.".config/hypr/lid.zsh".source = ./lid.zsh;
  home.file.".config/hypr/wallpaper.png".source = ./wallpaper.png;
}
