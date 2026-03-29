{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
    ];
  };

  services.dbus.enable = true;
  programs.dconf.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs.unstable.hyprland;
  };

  programs.ssh.startAgent = true;

  services.xserver = {
    enable = true;
    xkb = {
      layout = "pl";
      variant = "";
    };
  };

  programs.regreet = {
    enable = true;
    theme.name = "Adwaita";
    cursorTheme.name = "Adwaita";
    settings = {
      background = {
        path = "${./../../../images/wallpaper.png}";
        fit = "Cover";
      };
    };
  };

  programs.light.enable = true;
  hardware.i2c.enable = true;

  security.polkit.enable = true;
  security.pam.services.hyprlock.enable = true;

  environment.systemPackages = with pkgs; [
    ddcutil
    brightnessctl
    hyprpolkitagent
  ];
}
