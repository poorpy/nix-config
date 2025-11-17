{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption;
  cfg = config.jujutsu;
  tomlFormat = pkgs.formats.toml { };
in
{
  options.jujutsu = {
    enable = lib.mkEnableOption "Jujutsu VCS";
    user = mkOption {
      type = tomlFormat.type;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    assertions = [{
      assertion = cfg.user != { };
      message = "jujutsu.user must be set when jujutsu is enabled.";
    }];

    home.packages = with pkgs; [
      master.jjui
    ];

    programs.jujutsu = with pkgs; {
      enable = true;
      package = master.jujutsu;
      settings = {
        ui.default-command = "status";
        git.auto-local-bookmark = true;
        user = cfg.user;
      };
    };
  };
}
