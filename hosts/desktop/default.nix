{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./hyprland/nixos.nix

    inputs.self.nixosModules.base
    inputs.self.nixosModules.pipewire
  ];

  hardware.usb-modeswitch.enable = true;
  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  systemd.services.rtl8852cu-modeswitch = {
    description = "Switch RTL8852CU adapter from CD-ROM to WLAN mode";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.usb-modeswitch}/bin/usb_modeswitch -K -v 0bda -p 1a2b";
    };
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="1a2b", TAG+="systemd", ENV{SYSTEMD_WANTS}+="rtl8852cu-modeswitch.service"
  '';

  services.blueman.enable = true;

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    dnsovertls = "true";
  };

  networking = {
    hostName = "desktop";
    wireless.iwd.enable = true;
    nameservers = [
      "1.1.1.1#cloudflare-dns.com"
      "1.0.0.1#cloudflare-dns.com"
      "9.9.9.9"
      "8.8.8.8"
    ];
    firewall.allowedTCPPorts = [
      6443
    ];
  };

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
    wifi.backend = "iwd";
  };

  services.upower.enable = true;

  programs = {
    steam.enable = true;
    nix-ld.enable = true;
  };
  services.printing.enable = true;
  environment.systemPackages = with pkgs; [
    usbutils
    adwaita-icon-theme
  ];

  environment.sessionVariables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
