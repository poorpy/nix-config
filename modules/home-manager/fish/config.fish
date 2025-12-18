set -U fish_greeting
set -U EDITOR nvim
set -l fisher_url https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish

function _smart_tab_completion
    if commandline --paging-mode
        commandline -f down-line
    else
        commandline -f complete-and-search
    end
end

if status is-interactive
    if not functions -q fisher
        echo "Fisher not found. Installing..."
        curl -sL $fisher_url | source
        fisher update
    end

    set -g fish_color_command green
    set -g fish_color_param normal
    set -g fish_color_error red --bold
    set -g fish_color_quote yellow
    set -g fish_color_valid_path --underline

    starship init fish | source
    enable_transience

    uv generate-shell-completion fish | source 
    zoxide init --cmd cd fish | source

    fish_vi_key_bindings
    set -g fish_vi_force_cursor 1
    bind -M insert \t _smart_tab_completion


    function vimrc
        cd $HOME/.config/nvim/ && nvim init.lua && cd -
    end

    function nixrc
        cd $HOME/.config/nix-config/ && vim flake.nix && cd -
    end


    alias grep="grep --color=auto";
    alias ls="ls --color=auto";
    alias ll="ls -l";
    alias ":q"="exit";
    alias lg="lazygit"
    alias clipboard="wl-copy";
    alias primary="wl-copy --primary";
    alias gdb="gdb -quiet";
    alias terraform="tofu";
end


