{ inputs, outputs, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/wayland.nix
    ../../modules/nixos/pipewire.nix
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
    firewall.allowedTCPPorts = [
      6443
    ];

  };

  services.k3s = {
    enable = false;
    role = "server";
  };


  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      poorpy = import ./home-manager.nix;
    };
  };

  programs.steam.enable = true;
  services.printing.enable = true;
  environment.systemPackages = with pkgs; [
    gnome.adwaita-icon-theme
  ];
}
