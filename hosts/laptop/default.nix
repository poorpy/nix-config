{ inputs, outputs, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/xorg.nix
    # ../../modules/nixos/wayland.nix
    ../../modules/nixos/pipewire.nix
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

    nameservers = [

    ];
  };

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [ ];
  };

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      poorpy = import ./home-manager.nix;
    };
  };

  programs = {
    steam.enable = true;
    light.enable = true;
  };

  hardware.bluetooth.enable = true;
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
}
