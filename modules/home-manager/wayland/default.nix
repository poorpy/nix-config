{pkgs, ...}: {
  home.packages = with pkgs; [
    wl-clipboard
    mako
    swayidle
    sway-audio-idle-inhibit
    slurp
    grim
    swayimg
    libnotify # adds notify-send binary
    bemenu
  ];
}
