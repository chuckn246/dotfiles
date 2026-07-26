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
  "${XDG_DATA_HOME}/npm/bin"
  ${path}
)

fpath=(
  "${ZDOTDIR}/functions"
  "${ZDOTDIR}/completions"
  ${fpath}
)

export PATH FPATH

# Perl
eval "$(perl -I"${XDG_DATA_HOME}/perl5/lib/perl5" -Mlocal::lib="${XDG_DATA_HOME}/perl5")"

# Load environment, etc.
shell_files=(
  "${HOME}/.config/shell/aliases.sh"
  "${HOME}/.config/shell/functions.sh"
  "${HOME}/.config/shell/fzf.sh"
  "${HOME}/.config/shell/ls.sh"
)

for file in "${shell_files[@]}"; do
  if [ -r "${file}" ]; then
    . "${file}"
  fi
done

# Extras
umask 077

# vim: ft=zsh ts=2 sts=2 sw=2 sr et
