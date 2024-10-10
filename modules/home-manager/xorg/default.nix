{ pkgs, ... }: {

  home.packages = with pkgs; [
    feh
    xclip
    libnotify # adds notify-send binary
    betterlockscreen
  ];

}
