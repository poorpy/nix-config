{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    colorSchemes = builtins.fromTOML (builtins.readFile ./nordfox.toml);
    extraConfig = builtins.readFile ./wezterm.lua;
  };
}
