{ pkgs, ... }: {
  security.rtkit.enable = true;

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };

  environment.systemPackages = with pkgs; [
    alsa-utils
    wireplumber
    pulsemixer
    playerctl
    pavucontrol
  ];
}
