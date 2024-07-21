{ inputs, pkgs, lib, config, ... }: {
  home.packages = with pkgs; [
    rustup
    lld
    llvmPackages.bintools
  ];
}
