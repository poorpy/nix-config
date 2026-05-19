{pkgs, ...}: {
  home.packages = with pkgs; [
    typescript-language-server
    eslint
    nodenv
    nodejs
    bun
  ];
}
