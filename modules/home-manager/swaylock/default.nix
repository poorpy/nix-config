{ pkgs, ... }: {
  home.packages = with pkgs; [
    swaylock-effects
  ];
  home.file.".config/swaylock/config".source = ./config;
}
