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
    stateVersion = "25.11";
    homeDirectory = lib.mkDefault "/home/bmarczyn";
  };

  neovim.enable = true;
  fish.enable = true;
  tmux = {
    enable = true;
    useFish = true;
    sshAgentOverride = true;
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
    p4
    mpv
    pgcli
    docker
    docker-compose
    postgresql
    protobuf
    cassandra
    cockroachdb
    parallel
  ];
}
