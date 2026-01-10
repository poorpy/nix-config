{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  system.stateVersion = "25.11";

  nixpkgs = {
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
      };
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = ["root" "poorpy"];
      auto-optimise-store = true;
      flake-registry = "";
      nix-path = config.nix.nixPath;
    };

    package = pkgs.lixPackageSets.latest.lix;
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

    gc = {
      automatic = true;
      options = "--delete-older-than 8d";
    };
  };

  boot.supportedFilesystems = ["ntfs"];

  users.users.poorpy = {
    initialPassword = "correcthorsebatterystaple";
    isNormalUser = true;
    extraGroups = ["wheel" "docker" "video" "audio" "networkmanager" "input"];
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
    pathsToLink = ["/libexec"];
  };

  fonts.packages = with pkgs;
    [
      material-symbols
      jetbrains-mono
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

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
