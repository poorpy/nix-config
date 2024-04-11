{ inputs, pkgs, lib, config, ... }: {
  home.packages = with pkgs; [
    dune_3
    opam
  ];
}
