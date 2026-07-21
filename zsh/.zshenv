# ZSH
export ZDOTDIR="$HOME/.config/zsh"
export ZSH_CACHE_DIR="$ZDOTDIR/cache"
export ZCOMPDUMP="$ZSH_CACHE_DIR/completions/zcompdump"
export SHELL_SESSIONS_DISABLE=1

# EDITOR
export EDITOR=vim
export VISUAL=$EDITOR
export SUDO_EDITOR=$EDITOR

# GO
export GOPATH="${HOME}/.local/share/go"

# LESS
export PAGER=less
export LESS='--mouse -F -i -R -Q -J -M -W -X -x4 -z-4'
export LESSOPEN="|/opt/homebrew/bin/lesspipe.sh %s"

# NODE
export FNM_DIR="${HOME}/.local/share/fnm"

# RIPGREP
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"

# RUST
export CARGO_HOME="${HOME}/.local/share/cargo"
export RUSTUP_HOME="${HOME}/.local/share/rustup"

# UV
export UV_NO_MODIFY_PATH=1

# vim: ft=zsh ts=2 sts=2 sw=2 sr et
