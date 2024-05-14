export READER=zathura
export CC=gcc
export CXX=g++

if [[ -x "$(command -v rustc)" ]]; then 
    export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/src
fi

export GOPATH=$HOME/.go
export GOBIN=$HOME/.gobin

export PATH=$PATH:${HOME}/.cargo/bin
export PATH=$PATH:${HOME}/.local/bin
export PATH=$PATH:${HOME}/.luarocks/bin
export PATH=$PATH:$GOPATH/bin:$GOBIN
export PATH=$PATH:${HOME}/.nodenv/bin
export PATH=$PATH:/usr/local/bin

export P4CONFIG="${HOME}/.perforce"

export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

if [ -z ${XDG_RUNTIME_DIR} ]; then
    export XDG_RUNTIME_DIR="/tmp/${USER}-runtime"
fi

if [[ ! -d ${XDG_RUNTIME_DIR} ]]; then 
    mkdir ${XDG_RUNTIME_DIR}
fi

if [[ -x "$(command -v nodenv)" ]]; then
    eval "$(nodenv init -)"
fi

if [[ -x "$(command -v opam)" ]]; then
    eval $(opam env)
fi

if [[ -x "$(command -v brew)" ]]; then 
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ "$(uname)" == "Darwin" ]]; then 
    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
    fi
    if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
        source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
    fi
fi

zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
