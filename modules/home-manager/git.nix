{ config, lib, ... }:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.git;
  gitIniType =
    with types;
    let
      primitiveType = either str (either bool int);
      multipleType = either primitiveType (listOf primitiveType);
      sectionType = attrsOf multipleType;
      supersectionType = attrsOf (either multipleType sectionType);
    in
    attrsOf supersectionType;
in
{
  options.git = {
    enable = lib.mkEnableOption "Git VCS";
    userName = mkOption {
      type = types.str;
      default = "Bartosz Marczyński";
    };

    userEmail = mkOption {
      type = types.str;
      default = "marczynski.bartosz@gmail.com";
    };

    extraConfig = mkOption {
      type = types.either types.lines gitIniType;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;
      extraConfig = lib.recursiveUpdate
        {
          pull.rebase = true;
          push.autosetupremote = true;
          fetch.recursesubmodules = true;
          submodule.recurse = true;
          init.defaultbranch = "master";
          filter.lfs.required = true;
        }
        cfg.extraConfig;
      aliases = {
        branch-prune =
          "! git fetch --prune && git branch -vv | rg gone | awk '{print $1}' | xargs git branch -d";
      };
    };

  };
}
