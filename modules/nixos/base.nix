{ inputs, outputs, lib, config, pkgs, ... }: {
  system.stateVersion = "25.11";

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      outputs.overlays.nur
    ];

    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
      };
    };

    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    package = pkgs.lixPackageSets.latest.lix;

    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "root" "poorpy" ];
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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableGlobalCompInit = false;
  };
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
      htop-vim
    ];
    pathsToLink = [ "/libexec" ];
  };

  fonts.packages = with pkgs; [
    material-symbols
    jetbrains-mono
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  documentation.dev.enable = true;
  virtualisation.docker.enable = true;

  time.timeZone = "Europe/Warsaw";
  console.keyMap = "pl2";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pl_PL.UTF-8";
      LC_IDENTIFICATION = "pl_PL.UTF-8";
      LC_MEASUREMENT = "pl_PL.UTF-8";
      LC_MONETARY = "pl_PL.UTF-8";
      LC_NAME = "pl_PL.UTF-8";
      LC_NUMERIC = "pl_PL.UTF-8";
      LC_PAPER = "pl_PL.UTF-8";
      LC_TELEPHONE = "pl_PL.UTF-8";
      LC_TIME = "pl_PL.UTF-8";
    };
  };

  systemd.sleep.extraConfig = "HibernateDelaySec=1h";
}
