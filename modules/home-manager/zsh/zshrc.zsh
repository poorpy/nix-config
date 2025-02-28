ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

if [[ -f "${HOME}/.extra.zsh" ]]; then
    source "${HOME}/.extra.zsh"
fi

if [[ -d "${HOME}/.zfunc" ]]; then
    fpath+=~/.zfunc
fi


zinit light jeffreytse/zsh-vi-mode
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab


# if zsh startup is slow check if system-wide config contains compinit and disable ita
# autoload -Uz compinit && compinit

# load fzf after other plugins
zinit ice lucid wait
zinit snippet OMZP::fzf

zinit cdreplay -q

# bindkey -v
# bindkey -v '^?' backward-delete-char
# bindkey -v '^p' history-search-backward
# bindkey -v '^n' history-search-forward

HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

export EDITOR=nvim
export VISUAL=nvim
export ZVM_VI_EDITOR=nvim

export GOPATH=$HOME/.go
export GOBIN=$HOME/.gobin

export PATH=$PATH:${HOME}/.cargo/bin
export PATH=$PATH:${HOME}/.local/bin
export PATH=$PATH:${HOME}/.luarocks/bin
export PATH=$PATH:$GOPATH/bin:$GOBIN
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:${HOME}/.rd/bin

alias grep="grep --color=auto";
alias ls="ls --color=auto";
alias ll="ls -l";
alias ":q"="exit";
alias vimrc="cd \${HOME}/.config/nvim/; nvim init.lua; cd -; ";
alias nixrc="cd \${HOME}/.config/nix-config/; vim flake.nix; cd -; ";
alias lg="lazygit"
alias clipboard="wl-copy";
alias primary="wl-copy -p";
alias gdb="gdb -quiet";
alias dv='cd $(find ~/git/devenv/ -maxdepth 1 -mindepth 1 -type d -print | fzf) && devenv shell && cd -'

eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"
eval "$(uv generate-shell-completion zsh)"
