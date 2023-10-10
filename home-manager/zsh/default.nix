{ inputs, pkgs, lib, config, ... }: {
  programs.zsh = {
    enable = true;
    initExtra = (builtins.readFile ./initExtra.zsh);
    initExtraBeforeCompInit = (builtins.readFile ./initExtraBeforeCompInit.zsh);
    shellAliases = {
      grep = "grep --color=auto";
      ls = "ls --color=auto";
      ll = "ls -l";
      ":q" = "exit";
      vimrc = "cd \${HOME}/.config/nvim/; nvim init.lua; cd -; ";
      nixrc = "cd \${HOME}/.config/nix-config/; vim flake.nix; cd -; ";

      clipboard = "wl-copy";
      primary = "wl-copy -p";

      ssh = "noglob ssh";
      gdb = "gdb -quiet";
    };
  };

  programs.zsh.plugins = [
    {
      # will source zsh-autosuggestions.plugin.zsh
      name = "zsh-syntax-highlighting";
      src = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo = "zsh-syntax-highlighting";
        rev = "0.7.1";
        sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
      };
    }
  ];

  programs.zsh.oh-my-zsh = {
    enable = true;
    theme = "minimal";
    plugins = [
      "git"
      "systemd"
      "rust"
      "ripgrep"
      "pip"
      "poetry"
      "fzf"
      "golang"
    ];
  };
}
