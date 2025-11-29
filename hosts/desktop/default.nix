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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.initrd.kernelModules = [
    "8852cu"
  ];
  boot.extraModulePackages = with pkgs; [
    nur.repos.hilorioze.rtl8852cu
  ];
  boot.extraModprobeConfig = ''
    	options 8852cu rtw_switch_usb_mode=1
  '';

  services.blueman.enable = true;

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
  };

  networking = {
    hostName = "desktop";
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

  programs.steam.enable = true;
  services.printing.enable = true;
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
  ];

  environment.sessionVariables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
  };
}
