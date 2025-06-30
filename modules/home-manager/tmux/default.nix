{ config, lib, pkgs, ... }: {

  options.tmux.sshAgentOverride = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config = {
    home.packages = with pkgs; [
      sesh
    ];

    programs.tmux = {
      enable = true;
      mouse = true;
      baseIndex = 1;
      keyMode = "vi";
      prefix = "C-a";
      newSession = false;
      historyLimit = 10000;
      sensibleOnTop = true;
      terminal = "xterm-256color";
      extraConfig = lib.strings.concatStringsSep "\n" [
        ''
          set-option -sa terminal-overrides ",xterm*:Tc"
          set-option -g status-position bottom
          set-option -sg escape-time 10
          set-option -g update-environment -r 

          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R
          ${if config.tmux.sshAgentOverride then "setenv -g SSH_AUTH_SOCK $HOME/.ssh/ssh_auth_sock" else ""}

          bind v split-window -h -c "#{pane_current_path}"
          bind s split-window -v -c "#{pane_current_path}"
          unbind '"'
          unbind %

          bind-key "T" run-shell "sesh connect \"$(
            sesh list --icons | fzf-tmux -p 80%,70% \
              --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
              --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
              --bind 'tab:down,btab:up' \
              --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
              --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
              --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
              --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
              --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
              --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
              --preview-window 'right:55%' \
              --preview 'sesh preview {}'
          )\""
        ''
        (builtins.readFile ./nightfox.sh)
      ];

    };
  };
}
