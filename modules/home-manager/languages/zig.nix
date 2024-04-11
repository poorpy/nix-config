{ inputs, pkgs, lib, config, ... }: {
  home.packages = with pkgs; [
    zig
    zls
  ];
}
