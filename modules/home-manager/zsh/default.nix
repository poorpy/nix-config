{ inputs, pkgs, lib, config, ... }: {
  home.file.".zshrc".source = ./zshrc.zsh;
}
