{pkgs, ...}: {
  home.packages = with pkgs; [
    dune_3
    opam
  ];
}
