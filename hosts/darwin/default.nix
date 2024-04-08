{ inputs, outputs, lib, config, pkgs, ... }: {
  services.nix-daemon.enable = true;

  nix = {
    settings.trusted-users = [ "@admin" "bmarczyn" ];
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

  system.checks.verifyNixPath = false;
}
