{ inputs, pkgs, lib, config, ... }: {
  home.packages = with pkgs; [
    zig
    # zls # using locally compiled copy until 0.13 is in nixpkgs
  ];
}
