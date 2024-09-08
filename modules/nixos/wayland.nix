{ pkgs, ... }: {
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
    ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    configPackages = [
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  # programs.hyprland.enable = true;

  services.xserver = {
    enable = true;
    xkb = {
      layout = "pl";
      variant = "";
    };

    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
  };

  services.gnome.gnome-keyring.enable = true;

  security.polkit.enable = true;
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  environment.systemPackages = with pkgs; [
    polkit_gnome
    wlr-randr
    brightnessctl
    waybar
  ];

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
