{
  base = import ./base.nix;
  brave = import ./brave.nix;
  git = import ./git.nix;
  jujutsu = import ./jujutsu.nix;
  neovim = import ./neovim.nix;

  fish = import ./fish;
  languages = import ./languages;
  starship = import ./starship;
  sway = import ./sway;
  swaylock = import ./swaylock;
  tmux = import ./tmux;
  waybar = import ./waybar;
  wayland = import ./wayland;
  wezterm = import ./wezterm;
  ghostty = import ./ghostty;
  xorg = import ./xorg;
  zsh = import ./zsh;
}
