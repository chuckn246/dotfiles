# Shell identification
export SHELL_NAME=zsh
export SHELL_VERSION="${ZSH_VERSION}"

export ZDOTDIR="$HOME/.config/zsh"

# Environment
if [ -r "${HOME}/.config/shell/environment.sh" ]; then
  . "${HOME}/.config/shell/environment.sh"
fi

# ZSH
export ZSH_CACHE_DIR="$ZDOTDIR/cache"
export ZCOMPDUMP="$ZSH_CACHE_DIR/completions/zcompdump"
export SHELL_SESSIONS_DISABLE=1

export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
export ZCOMPDUMP="${ZSH_CACHE_DIR}/completions/zcompdump"

# vim: ft=zsh ts=2 sts=2 sw=2 sr et
