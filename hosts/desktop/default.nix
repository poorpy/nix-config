{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    ../../nixos/shared.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/347d676c-cc04-499f-9de2-dc7f1f058488";
      preLVM = true;
      allowDiscards = true;
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      poorpy = import ./home-manager.nix;
    };
  };

  programs = { };
  environment.systemPackages = with pkgs; [
    gnome.adwaita-icon-theme
  ];
}
