# Prevent duplicate entries even if this file is sourced multiple times
typeset -U path fpath

# If Homebrew is installed, initialize its environment
brew_binary=''
[[ -x "/opt/homebrew/bin/brew" ]] && brew_binary="/opt/homebrew/bin/brew"

# Prepend Homebrew paths if available
if [[ -n "${brew_binary}" ]]; then
  eval "$(${brew_binary} shellenv)"
  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_REQUIRE_TAP_TRUST=1
fi

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

# Extras
umask 077

# vim: ft=zsh ts=2 sts=2 sw=2 sr et
