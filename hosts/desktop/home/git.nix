{ inputs, pkgs, lib, config, ... }: {
  programs.git = {
    enable = true;
    userName = "Bartosz Marczyński";
    userEmail = "marczynski.bartosz@gmail.com";
    extraConfig = {
      pull.rebase = true;
      push.autosetupremote = true;
      fetch.recursesubmodules = true;
      submodule.recurse = true;
      init.defaultbranch = "master";
    };

    includes = [ ];

    aliases = {
      branch-prune =
        "! git fetch --prune && git branch -vv | rg gone | awk '{print $1}' | xargs git branch -d";
    };
  };
}
