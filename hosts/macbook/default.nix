{ inputs, outputs, lib, config, pkgs, ... }:
{

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      inputs.neovim-nightly-overlay.overlay
    ];

    config.allowUnfree = true;

    hostPlatform = lib.mkDefault "aarch64-darwin";
  };

  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    trustedUsers = [
      "@admin"
      "@bmarczyn"
    ];

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      extra-platforms = "x86_64-darwin aarch64-darwin";
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 8d";
    };
  };


  users.nix.configureBuildUsers = true;

  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
  # nix.extraOptions = ''
  #   auto-optimise-store = true
  #   experimental-features = nix-command flakes
  # '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
  #   extra-platforms = x86_64-darwin aarch64-darwin
  # '';

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [
    terminal-notifier
  ];

  programs.nix-index.enable = true;

  # Fonts
  fonts.enableFontDir = true;
  fonts.packages = with pkgs; [
    material-symbols
    unstable.nerdfonts
  ];

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

}

