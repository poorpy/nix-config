{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption;
  cfg = config.tmux;
  # Pin floax to a per-session-aware revision. This SAME package must be used
  # both for the loaded plugin and for floaxSync below; otherwise the popup
  # bindings end up running two different floax.sh scripts that target two
  # different sessions.
  floax = pkgs.tmuxPlugins.tmux-floax.overrideAttrs (oldAttrs: {
    src = pkgs.fetchFromGitHub {
      owner = "omerxx";
      repo = "tmux-floax";
      rev = "976115461e2c92d8e1659f5b08cf6d7347baf8a2";
      hash = "sha256-zgI+ArGMRSxPF5/k3PItsaB7cOpty9tv1wJcgqkVtuY=";
    };
  });
  # Sync the floax scratch session to the current pane's directory, then
  # open/toggle the floax popup. Bound to <prefix>+g (the on-demand cwd change),
  # while M-g opens the popup WITHOUT changing the cwd. Automatic path-changing
  # is disabled via @floax-change-path below so this is the only thing that cds.
  #
  # The session name must match floax's own logic: with @floax-per-session
  # 'true' the popup lives in `<base>_<origin-session>`, otherwise just
  # `<base>`. Hardcoding `scratch` here would target the wrong session and
  # leave the per-session popup unsynced.
  floaxSync = pkgs.writeShellScript "floax-sync" ''
    dir="$(tmux display-message -p '#{pane_current_path}')"
    session="$(tmux display-message -p '#{session_name}')"
    base="$(tmux show-option -gqv '@floax-session-name')"
    base="''${base:-scratch}"
    if [ "$(tmux show-option -gqv '@floax-per-session')" = "true" ]; then
      scratch="''${base}_''${session}"
    else
      scratch="$base"
    fi
    if tmux has-session -t "$scratch" 2>/dev/null; then
      tmux send-keys -R -t "$scratch" "cd \"$dir\"" C-m
    fi
    exec ${floax}/share/tmux-plugins/tmux-floax/scripts/floax.sh
  '';
  # tmux's OSC52 clipboard passthrough (set-clipboard on) does NOT survive the
  # display-popup overlay that floax uses, so copying from the scratch session
  # silently fails when relying on OSC52 alone. Where a local clipboard tool is
  # available we pipe selections straight to it (via copy-command), which works
  # regardless of the popup. The backend is selected by the tmux.clipboard
  # option:
  #
  #   wayland -> wl-copy (regular clipboard + primary selection)
  #   macos   -> pbcopy
  #   osc52   -> no copy-command; rely solely on OSC52 passthrough. Use this on
  #              remote/SSH hosts with no local clipboard (e.g. a Linux VM
  #              reached over SSH from Ghostty on macOS). Copying from the floax
  #              popup is inherently limited here due to the popup OSC52
  #              limitation, but normal panes copy to the host clipboard fine.
  copyCommand =
    if cfg.clipboard == "wayland"
    then
      pkgs.writeShellScript "tmux-copy-wayland" ''
        content="$(cat)"
        printf '%s' "$content" | ${pkgs.wl-clipboard}/bin/wl-copy
        printf '%s' "$content" | ${pkgs.wl-clipboard}/bin/wl-copy --primary
      ''
    else if cfg.clipboard == "macos"
    then "/usr/bin/pbcopy"
    else "";
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
    clipboard = mkOption {
      type = lib.types.enum ["wayland" "macos" "osc52"];
      default =
        if pkgs.stdenv.isDarwin
        then "macos"
        else "wayland";
      description = ''
        Clipboard backend for copy-mode selections.
        "wayland" pipes to wl-copy (clipboard + primary), "macos" pipes to
        pbcopy, and "osc52" relies solely on tmux's OSC52 passthrough. Use
        "osc52" on remote/SSH hosts with no local clipboard, e.g. a Linux VM
        reached over SSH from Ghostty on macOS.
      '';
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
          plugin = floax;
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
          ${lib.optionalString (copyCommand != "") "set -s copy-command '${copyCommand}'"}
          set -g allow-passthrough on
          set -g extended-keys on
          set -g extended-keys-format csi-u
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

          # Open the floax popup. Both keys target the same per-session scratch
          # session; only <prefix>+g changes the popup's cwd to the current pane
          # path (via floaxSync). M-g opens it without touching the cwd.
          bind g run-shell "${floaxSync}"
          bind -n M-g run-shell "${floax}/share/tmux-plugins/tmux-floax/scripts/floax.sh"

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
