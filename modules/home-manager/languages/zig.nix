{ outputs, pkgs, lib, config, ... }: {

  # nixpkgs = {
  #   overlays = [
  #     outputs.overlays.zig-packages
  #   ];
  # };

  home.packages = [
    # pkgs.zls
    # pkgs.zigpkgs.master
  ];
}
