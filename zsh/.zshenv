# Shell identification
export SHELL_NAME=zsh
export SHELL_VERSION="${ZSH_VERSION}"

# Environment
if [ -r "${HOME}/.config/shell/environment.sh" ]; then
  . "${HOME}/.config/shell/environment.sh"
fi

# ZSH
export ZDOTDIR="$HOME/.config/zsh"
export SHELL_SESSIONS_DISABLE=1
export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
export ZCOMPDUMP="${ZSH_CACHE_DIR}/completions/zcompdump"

# vim: ft=zsh ts=2 sts=2 sw=2 sr et
