{ outputs, pkgs, lib, config, ... }: {

  home.packages = with pkgs; [
    zls
    zig
  ];
}
