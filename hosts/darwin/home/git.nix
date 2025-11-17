{ inputs, pkgs, lib, config, ... }: {
  programs.git = {
    enable = true;
    userName = "Bartosz Marczyński";
    userEmail = "bmarczyn@akamai.com";
    extraConfig = {
      pull.rebase = true;
      push.autosetupremote = true;
      fetch.recursesubmodules = true;
      submodule.recurse = true;
      init.defaultbranch = "master";
      url."ssh://git@git.source.akamai.com:7999" = {
        insteadOf = "https://git.source.akamai.com";
      };
      filter.lfs.required = true;
    };

    includes = [ ];

    aliases = {
      branch-prune =
        "! git fetch --prune && git branch -vv | rg gone | awk '{print $1}' | xargs git branch -d";
    };
  };
}
