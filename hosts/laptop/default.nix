{ inputs, outputs, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/wayland.nix
    ../../modules/nixos/pipewire.nix
  ];

  hardware.usb-modeswitch.enable = true;
  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.luks.devices."luks-28c06527-3ee0-41dd-9b18-149d624dbd97".device = "/dev/disk/by-uuid/28c06527-3ee0-41dd-9b18-149d624dbd97";
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.blueman.enable = true;
  services.tlp.enable = true;
  services.pcscd.enable = true;
  services.printing.enable = true;
  services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.caps2esc ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
  };

  networking = {
    hostName = "laptop";
    wireless.iwd.enable = true;
    nameservers = [ "1.1.1.1" "9.9.9.9" "8.8.8.8" ];
    firewall.allowedTCPPorts = [
      6443
    ];
  };

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
    wifi.backend = "iwd";
  };

  
  programs = {
    steam.enable = true;
    light.enable = true;
  nix-ld = {
    enable = true;
    libraries = with pkgs; [ ];
  };
  };

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
  ];
  environment.sessionVariables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
  };
}
