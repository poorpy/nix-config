{pkgs, ...}: {
  home.packages = with pkgs; [
    zls_0_14
    zig_0_14
  ];
}
