{ inputs, outputs, lib, config, pkgs, ... }: {
  system.stateVersion = "22.11";

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

  users.users.poorpy = {
    initialPassword = "correcthorsebatterystaple";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "video" "audio" "networkmanager" "input" ];
    description = "poorpy";
    shell = pkgs.zsh;
    packages = with pkgs; [
      home-manager
    ];
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    nscd = {
      enable = true;
      enableNsncd = true;
    };
  };

  programs.ssh.startAgent = true;
  programs.zsh.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  environment = {
    systemPackages = with pkgs; [
      man-pages
      man-pages-posix

      git
      curl
      fzf
      ripgrep
      gcc
      fd
      fzf
      gnumake
    ];
    pathsToLink = [ "/libexec" ];
  };

  fonts.packages = with pkgs; [
    material-symbols
    nerdfonts
  ];

  documentation.dev.enable = true;
  virtualisation.docker.enable = true;

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

  systemd.sleep.extraConfig = "HibernateDelaySec=1h";
}
