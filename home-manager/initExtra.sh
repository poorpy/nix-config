export READER=zathura
export CC=gcc
export CXX=g++

export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/src

export GOPATH=$HOME/.go
export GOBIN=$HOME/.gobin

export PATH=$PATH:${HOME}/.cargo/bin
export PATH=$PATH:${HOME}/.local/bin
export PATH=$PATH:${HOME}/.yarn/bin:${HOME}/.config/yarn/global/node_modules/.bin
export PATH=$PATH:${HOME}/.luarocks/bin
export PATH=$PATH:$GOPATH/bin:$GOBIN

export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

 if ! pgrep -u "$USER" ssh-agent > /dev/null; then
     ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
 fi
 if [[ ! "$SSH_AUTH_SOCK" || "$SSH_AUTH_SOCK" = "$XDG_RUNTIME_DIR/ssh-agent.socket" ]]; then
     source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
 fi
