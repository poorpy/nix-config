{ inputs, pkgs, lib, config, ... }: {
  home.packages = with pkgs; [
    nodePackages.pyright
  ];
}
