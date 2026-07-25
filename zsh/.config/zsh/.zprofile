# Prevent duplicate entries even if this file is sourced multiple times
typeset -U path fpath

# If Homebrew is installed, initialize its environment
if [ -f "${HOME}/.config/shell/homebrew.sh" ]; then
  . "${HOME}/.config/shell/homebrew.sh"
fi

# PATH
if [[ "$(uname -s)" == "Darwin" ]]; then
  # macOS: Remove our paths if path_helper moved them
  path=("${(@)path:#${HOME}/.local/bin}")
  path=("${(@)path:#${GOPATH}/bin}")
  path=("${(@)path:#${CARGO_HOME}/bin}")
fi

path=(
  "${HOME}/.local/bin"
  "${CARGO_HOME}/bin"
  "${GOPATH}/bin"
  ${path}
)

fpath=(
  "${ZDOTDIR}/functions"
  "${ZDOTDIR}/completions"
  ${fpath}
)

export PATH FPATH

# Aliases
if [ -f "${HOME}/.config/shell/aliases.sh" ]; then
  . "${HOME}/.config/shell/aliases.sh"
fi

# Functions
if [ -f "${HOME}/.config/shell/functions.sh" ]; then
  . "${HOME}/.config/shell/functions.sh"
fi

# Extras
umask 077

# vim: ft=zsh ts=2 sts=2 sw=2 sr et
