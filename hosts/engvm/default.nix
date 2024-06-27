{ inputs, outputs, lib, config, pkgs, ... }: {
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true;
    };

    hostPlatform = lib.mkDefault "aarch64-darwin";
  };

  nix = {
    settings.trusted-users = [ "bmarczyn" "root" ];
    gc = {
      user = "root";
      automatic = true;
      interval = { Weekday = 1; Hour = 0; Minute = 0; };
      options = "--delete-older-than 30d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  users.users = {
    bmarczyn = {
      home = lib.mkDefault "/home/bmarczyn";
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      bmarczyn = import ./home-manager.nix;
    };
  };

  system.stateVersion = "22.11";
  system.checks.verifyNixPath = false;
  services.nix-daemon.enable = true;
}
