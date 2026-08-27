{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.self.homeManagerModules.zsh
    inputs.self.homeManagerModules.fish
    inputs.self.homeManagerModules.tmux
    inputs.self.homeManagerModules.wezterm
    inputs.self.homeManagerModules.starship

    inputs.self.homeManagerModules.base
    inputs.self.homeManagerModules.git
    inputs.self.homeManagerModules.neovim
    inputs.self.homeManagerModules.jujutsu

    inputs.self.homeManagerModules.languages.go
    inputs.self.homeManagerModules.languages.cpp
    inputs.self.homeManagerModules.languages.rust
    inputs.self.homeManagerModules.languages.java
    inputs.self.homeManagerModules.languages.python
    inputs.self.homeManagerModules.languages.javascript
  ];

  home = {
    username = "bmarczyn";
    enableNixpkgsReleaseCheck = false;
    stateVersion = "26.05";
    homeDirectory = lib.mkDefault "/home/bmarczyn";
  };

  neovim.enable = true;
  fish.enable = true;
  tmux = {
    enable = true;
    useFish = true;
    sshAgentOverride = true;
    # No local clipboard on the VM; rely on OSC52 passthrough back to Ghostty
    # on macOS over SSH.
    clipboard = "osc52";
  };

  git = {
    enable = true;
    user = {
      name = "Bartosz Marczyński";
      email = "bmarczyn@akamai.com";
    };
    settings = {
      url."ssh://git@git.source.akamai.com:7999" = {
        insteadOf = "https://git.source.akamai.com";
      };
    };
  };

  jujutsu = {
    enable = true;
    user = {
      email = "bmarczyn@akamai.com";
      name = "Bartosz Marczyński";
    };
  };

  home.packages = with pkgs; [
    mpv
    pgcli
    curl
    postgresql
    protobuf
    cassandra
    cockroachdb
    moreutils
    master.buf
    swig
    lazysql
    rainfrog
    goose
    sqlfluff
    dive

    rtk
    tokei
    master.github-copilot-cli
  ];
}
