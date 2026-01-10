{pkgs, ...}: {
  home.file.".zshrc".source = ./zshrc.zsh;
  home.packages = with pkgs; [
    starship
    zsh
  ];
}
