{ inputs, pkgs, lib, config, ... }: {
  
  nixpkgs.config.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
