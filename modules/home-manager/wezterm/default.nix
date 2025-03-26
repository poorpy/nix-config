{ inputs, pkgs, lib, config, ... }: {

  programs.wezterm = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    enableZshIntegration = true;
    colorSchemes = (builtins.fromTOML (builtins.readFile ./nordfox.toml));
    extraConfig = (builtins.readFile ./wezterm.lua);
  };
}
