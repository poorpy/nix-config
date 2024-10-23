{ inputs, pkgs, lib, config, ... }: {

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
        set-option -g update-environment "SSH_AUTH_SOCK SSH_CONNECTION DISPLAY"

        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        bind v split-window -h -c "#{pane_current_path}"
        bind s split-window -v -c "#{pane_current_path}"
        unbind '"'
        unbind %

      ''
      (builtins.readFile ./nightfox.sh)
    ];

  };
}
