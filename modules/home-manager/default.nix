{
  base = import ./base.nix;
  brave = import ./brave.nix;
  git = import ./git.nix;
  jujutsu = import ./jujutsu.nix;
  neovim = import ./neovim.nix;

  fish = import ./fish;
  languages = import ./languages;
  starship = import ./starship;
  tmux = import ./tmux;
  wezterm = import ./wezterm;
  ghostty = import ./ghostty;
  zsh = import ./zsh;
}
