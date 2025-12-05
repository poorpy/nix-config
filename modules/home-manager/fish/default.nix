{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.fish;
in
{
  options.fish = {
    enable = lib.mkEnableOption "Fish shell";
  };

  config = mkIf cfg.enable {
    home.file.".config/fish/config.fish".source = ./config.fish;
    home.file.".config/fish/fish_plugins".source = ./fish_plugins;
    home.packages = with pkgs; [
      starship
      fish
    ];
  };
}
