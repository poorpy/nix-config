{ pkgs, ... }: {

  home.packages = with pkgs; [
    wl-clipboard
    mako
    swayidle
    slurp
    grim
    swayimg
  ];

}
