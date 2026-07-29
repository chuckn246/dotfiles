# Shell identification
export SHELL_NAME=bash
export SHELL_VERSION="${BASH_VERSION}"

# PATH
path_prepend() {
  [ -d "${1}" ] || return
  case ":${PATH}:" in
    *":${1}:"*) ;;
    *) PATH="${1}:${PATH}" ;;
  esac
}

path_append() {
  [ -d "${1}" ] || return
  case ":${PATH}:" in
    *":${1}:"*) ;;
    *) PATH="${PATH}:${1}" ;;
  esac
}

# If Homebrew is installed, initialize its environment
if [ -f "${HOME}/.config/shell/homebrew.sh" ]; then
  . "${HOME}/.config/shell/homebrew.sh"
fi

# path_prepend  "/opt/bin"
# path_prepend  "${HOME}/bin"
# path_prepend  "${HOME}/.local/bin"
path_append "${XDG_DATA_HOME}/npm/bin"

# History
export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTTIMEFORMAT="%F %H:%M: "

# Perl
eval "$(perl -I"${XDG_DATA_HOME}/perl5/lib/perl5" -Mlocal::lib="${XDG_DATA_HOME}/perl5")"

# Do not attempt to use askpass program; only use terminal
if ! command -v ssh-askpass >/dev/null 2>&1; then
  export SSH_ASKPASS_REQUIRE=never
fi

# Load environment, etc.
shell_files=(
  "${HOME}/.config/shell/environment.sh"
  "${HOME}/.config/bash/prompt.sh"
  "${HOME}/.config/shell/aliases.sh"
  "${HOME}/.config/shell/functions.sh"
  "${HOME}/.config/shell/fzf.sh"
  "${HOME}/.config/shell/ls.sh"
  "${HOME}/.bashrc"
)

for file in "${shell_files[@]}"; do
  if [ -r "${file}" ]; then
    . "${file}"
  fi
done

if ! command -v brew >/dev/null 2>&1; then
  path_append "${FNM_DIR}"
fi

# vim: ft=sh ts=2 sts=2 sw=2 sr et
