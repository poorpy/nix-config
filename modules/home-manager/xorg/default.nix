{pkgs, ...}: {
  home.packages = with pkgs; [
    feh
    xclip
    scrot
    libnotify # adds notify-send binary
    betterlockscreen
  ];
}
