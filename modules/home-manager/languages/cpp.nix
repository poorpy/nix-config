{ inputs, pkgs, lib, config, ... }: {
  home.packages = with pkgs; [
    bear
    ccls
    cmake
    clang
    clang-tools
  ];
}
