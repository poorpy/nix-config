# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      inputs.neovim-nightly-overlay.overlay
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };

    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-41a833c1-a0bc-4556-b60a-47052a73c491" = {
    device = "/dev/disk/by-uuid/41a833c1-a0bc-4556-b60a-47052a73c491";
    keyFile = "/crypto_keyfile.bin";
  };

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 8d";
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  security.polkit.enable = true;
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  time.timeZone = "Europe/Warsaw";

  console.keyMap = "pl2";

  i18n = {
    defaultLocale = "en_US.utf8";
    extraLocaleSettings = {
      LC_ADDRESS = "pl_PL.utf8";
      LC_IDENTIFICATION = "pl_PL.utf8";
      LC_MEASUREMENT = "pl_PL.utf8";
      LC_MONETARY = "pl_PL.utf8";
      LC_NAME = "pl_PL.utf8";
      LC_NUMERIC = "pl_PL.utf8";
      LC_PAPER = "pl_PL.utf8";
      LC_TELEPHONE = "pl_PL.utf8";
      LC_TIME = "pl_PL.utf8";
    };
  };

  hardware.bluetooth.enable = true;

  users.users = {
    poorpy = {
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "video" "audio" "networkmanager" "input" ];
      description = "poorpy";
      shell = pkgs.zsh;
      packages = with pkgs; [
        alacritty
        firefox
        pavucontrol
        prismlauncher
        home-manager
        texlive.combined.scheme-full
      ];
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  services = {
    dbus.enable = true;
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns = true;
    };

    xserver = {
      enable = true;

      layout = "pl";
      xkbVariant = "";

      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };

      };

      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          middleEmulation = true;
          naturalScrolling = true;
        };
      };
    };

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber.enable = true;
      pulse.enable = true;
    };

    tlp.enable = true;
  };

  fonts.fonts = with pkgs; [
    material-symbols
    unstable.nerdfonts
  ];

  documentation.dev.enable = true;
  virtualisation.docker.enable = true;

  programs = {
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
    };
    steam.enable = true;
    zsh.enable = true;
    light.enable = true;
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
    ssh.startAgent = true;
  };

  environment = {
    systemPackages = with pkgs; [
      man-pages
      man-pages-posix

      dash
      git
      curl
      fzf
      ripgrep
      rustup
      gcc
      fd
      fzf
      ranger
      gnumake
      xclip

      alsa-utils
      wireplumber
      pulsemixer

      polkit_gnome
      wlr-randr
      brightnessctl
    ];
    pathsToLink = [ "/libexec" ];
  };

  systemd = {
    sleep.extraConfig = '' 
    HibernateDelaySec=1h
    '';
    user.services.polkit-gnome-authentication-agent-1 = {
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
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
