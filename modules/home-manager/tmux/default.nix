{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption;
  cfg = config.tmux;
  floax = pkgs.tmuxPlugins.tmux-floax;
  # Sync the floax `scratch` session to the current pane's directory, then
  # open the floax popup. Bound to <prefix>+g so the cwd change is manual
  # (automatic path-changing is disabled via @floax-change-path below).
  floaxSync = pkgs.writeShellScript "floax-sync" ''
    dir="$(tmux display-message -p '#{pane_current_path}')"
    if tmux has-session -t scratch 2>/dev/null; then
      tmux send-keys -R -t scratch "cd \"$dir\"" C-m
    fi
    exec ${floax}/share/tmux-plugins/tmux-floax/scripts/floax.sh
  '';
in {
  options.tmux = {
    enable = mkEnableOption "tmux terminal multiplexer";
    sshAgentOverride = mkOption {
      type = lib.types.bool;
      default = false;
    };
    useFish = mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !cfg.useFish || config.fish.enable;
        message = "You cannot use 'tmux.useFish' unless Fish is enabled.";
      }
    ];

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
      terminal = "screen-256color";
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = tmux-floax.overrideAttrs (oldAttrs: {
            src = pkgs.fetchFromGitHub {
              owner = "omerxx";
              repo = "tmux-floax";
              rev = "976115461e2c92d8e1659f5b08cf6d7347baf8a2";
              hash = "sha256-zgI+ArGMRSxPF5/k3PItsaB7cOpty9tv1wJcgqkVtuY=";
            };
          });
          extraConfig = ''
            set -g @floax-bind '-n M-g'
            # Don't auto-cd the floax pane to the current path on open;
            # use <prefix>+g (see floaxSync) to change the dir on demand.
            set -g @floax-change-path 'false'
            set -g @floax-per-session 'true'
          '';
        }
      ];
      extraConfig = lib.strings.concatStringsSep "\n" [
        ''
          set-option -sa terminal-overrides ",xterm*:Tc"
          set-option -g status-position bottom
          set-option -sg escape-time 10
          set-option -g update-environment -r
          set -g mouse on
          set -s set-clipboard on
          set -g allow-passthrough on
          bind C-a send-prefix

          ${
            if config.tmux.useFish
            then "set-option -g default-shell ~/.nix-profile/bin/fish"
            else ""
          }
          ${
            if config.tmux.useFish
            then "set-option -g default-command \"~/.nix-profile/bin/fish -l\""
            else ""
          }

          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R
          ${
            if config.tmux.sshAgentOverride
            then "setenv -g SSH_AUTH_SOCK $HOME/.ssh/ssh_auth_sock"
            else ""
          }

          bind v split-window -h -c "#{pane_current_path}"
          bind s split-window -v -c "#{pane_current_path}"
          unbind '"'
          unbind %

          # Sync floax scratch dir to current pane path, then open the popup.
          bind g run-shell "${floaxSync}"

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
