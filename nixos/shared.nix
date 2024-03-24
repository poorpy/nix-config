{ inputs, outputs, lib, config, pkgs, ... }: {

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      inputs.neovim-nightly-overlay.overlay
    ];

    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      };
    };

    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 8d";
    };
  };

  boot.supportedFilesystems = [ "ntfs" ];

  security.polkit.enable = true;
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  users.users = {
    poorpy = {
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "video" "audio" "networkmanager" "input" ];
      description = "poorpy";
      shell = pkgs.zsh;
      packages = with pkgs; [
        home-manager
      ];
    };
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

  hardware.pulseaudio.enable = false;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
    ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  fonts.packages = with pkgs; [
    material-symbols
    unstable.nerdfonts
  ];

  documentation.dev.enable = true;
  virtualisation.docker.enable = true;

  services = {
    printing.enable = true;
    pcscd.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    nscd = {
      enable = true;
      enableNsncd = true;
    };
  };

  services.xserver = {
    enable = true;
    xkb = {
      layout = "pl";
      variant = "";
    };

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    wireplumber.enable = true;
    pulse.enable = true;
  };

  programs = {
    hyprland.enable = true;
    steam.enable = true;
    zsh.enable = true;
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
      gcc
      fd
      fzf
      ranger
      gnumake

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

  system.stateVersion = "22.11";
}
