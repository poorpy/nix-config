export READER=zathura
export CC=gcc
export CXX=g++

export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/src

export GOPATH=$HOME/.go
export GOBIN=$HOME/.gobin

export PATH=$PATH:${HOME}/.cargo/bin
export PATH=$PATH:${HOME}/.local/bin
export PATH=$PATH:${HOME}/.luarocks/bin
export PATH=$PATH:$GOPATH/bin:$GOBIN

export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

export TERM=wezterm
