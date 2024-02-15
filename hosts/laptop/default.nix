{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    ../../nixos/shared.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  boot.initrd.luks.devices."luks-41a833c1-a0bc-4556-b60a-47052a73c491" = {
    device = "/dev/disk/by-uuid/41a833c1-a0bc-4556-b60a-47052a73c491";
    keyFile = "/crypto_keyfile.bin";
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;

    firewall = {
      allowedUDPPorts = [ 51820 ];
    };
    extraHosts = ''
      172.16.201.10 registry.gitlab.svexa.com
      172.16.201.10 gitlab.svexa.com
    '';
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      poorpy = import ../../home-manager/home.nix;
    };
  };

  programs = { 
    steam.enable = true;
    light.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.tlp.enable = true;
  services.pcscd.enable = true;
}
