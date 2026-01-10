{pkgs, ...}: {
  home.packages = with pkgs; [
    nodePackages.typescript-language-server
    nodePackages.eslint
    nodenv
    nodejs
  ];
}
