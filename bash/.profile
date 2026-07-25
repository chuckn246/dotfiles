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

# History
export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTTIMEFORMAT="%F %H:%M: "

# Do not attempt to use askpass program; only use terminal
if ! command -v ssh-askpass >/dev/null 2>&1; then
  export SSH_ASKPASS_REQUIRE=never
fi

if [ -f "${HOME}/.config/bash/prompt.sh" ]; then
  . "${HOME}/.config/bash/prompt.sh"
fi

if [ -f "${HOME}/.config/shell/aliases.sh" ]; then
  . "${HOME}/.config/shell/aliases.sh"
fi

if [ -f "${HOME}/.config/shell/functions.sh" ]; then
  . "${HOME}/.config/shell/functions.sh"
fi

if [ -r "${HOME}/.bashrc" ]; then
  . "${HOME}/.bashrc"
fi

# vim: ft=sh ts=2 sts=2 sw=2 sr et
