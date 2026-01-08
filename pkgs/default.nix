{ pkgs ? (import ../nixpkgs.nix) { } }: {
  rtl8852cu = pkgs.linuxPackages.callPackage ./rtl8852cu { };
}
