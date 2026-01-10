{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.git;
  gitIniType = with types; let
    primitiveType = either str (either bool int);
    multipleType = either primitiveType (listOf primitiveType);
    sectionType = attrsOf multipleType;
    supersectionType = attrsOf (either multipleType sectionType);
  in
    attrsOf supersectionType;
in {
  options.git = {
    enable = lib.mkEnableOption "Git VCS";

    user = mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrs;
        options = {
          name = lib.mkOption {type = types.str;};
          email = lib.mkOption {type = types.str;};
        };
      };
    };

    settings = mkOption {
      type = types.either types.lines gitIniType;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.user != {};
        message = "git.user must be set when git is enabled.";
      }
    ];

    home.packages = with pkgs; [
      lazygit
      pre-commit
      git-lfs
    ];

    programs.git = {
      enable = true;
      settings =
        lib.recursiveUpdate
        {
          user = cfg.user;
          pull.rebase = true;
          push.autosetupremote = true;
          fetch.recursesubmodules = true;
          submodule.recurse = true;
          init.defaultbranch = "master";
          filter.lfs.required = true;
          alias = {
            branch-prune = "! git fetch --prune && git branch -vv | rg gone | awk '{print $1}' | xargs git branch -d";
          };
        }
        cfg.settings;
    };
  };
}
