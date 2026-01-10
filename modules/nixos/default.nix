{
  base = import ./base.nix;
  pipewire = import ./pipewire.nix;
  wayland = import ./wayland.nix;
  xorg = import ./xorg.nix;
}
