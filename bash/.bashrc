# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Use a vi-style command line editing interface
set -o vi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# "**" used in a pathname expansion context will match all
# files and zero or more directories and subdirectories.
shopt -s globstar 2>/dev/null || true

# append to the history file, don't overwrite it
shopt -s histappend 2>/dev/null || true

# Set secure umask
umask 027

# GPG
GPG_TTY=$(tty)
export GPG_TTY

# Disable <C-s> functionality for vim.surround
stty -ixon

# enable color support of ls and also add handy aliases
if command -v dircolors >/dev/null; then
  if [ -f "${HOME}/.dircolors" ]; then
    eval "$(dircolors -b "${HOME}/.dircolors")"
  else
    eval "$(dircolors -b)"
  fi
fi

# Bash Completion
if ! shopt -oq posix; then
  for completion in \
    "/etc/bash_completion" \
    "/usr/share/bash-completion/bash_completion" \
    "/usr/local/etc/profile.d/bash_completion.sh" \
    "/usr/local/share/bash-completion/bash_completion" \
    "/opt/homebrew/etc/profile.d/bash_completion.sh" \
    "/opt/homebrew/share/bash-completion/bash_completion"
  do
    if [ -r "${completion}" ]; then
      . "${completion}"
      break
    fi
  done

  if command -v aws_completer >/dev/null; then
    complete -C "$(command -v aws_completer)" aws
  fi

  # fzf key bindings
  if command -v fzf >/dev/null 2>&1; then
    FZF_DIR="${HOMEBREW_PREFIX}/opt/fzf/shell"
    if [ -r "${FZF_DIR}/key-bindings.bash" ]; then
      source "${FZF_DIR}/key-bindings.bash"
    elif [ -r /usr/share/doc/fzf/examples/key-bindings.bash ]; then
      source /usr/share/doc/fzf/examples/key-bindings.bash
    elif [ -r /usr/share/fzf/key-bindings.bash ]; then
      source /usr/share/fzf/key-bindings.bash
    fi
    if [ -r "${FZF_DIR}/completion.bash" ]; then
      source "${FZF_DIR}/completion.bash"
    elif [ -r /usr/share/doc/fzf/examples/completion.bash ]; then
      source /usr/share/doc/fzf/examples/completion.bash
    elif [ -r /usr/share/fzf/completion.bash ]; then
      source /usr/share/fzf/completion.bash
    fi
  fi

  #if [ -f "${HOME}/.hosts" ]; then
  #  complete -A hostname -o default curl dig host nc netcat ping telnet wget
  #fi
fi

# load extra files - aliases, functions, etc.
if [ -d "${HOME}/.bashrc.d" ]; then
  for file in "${HOME}"/.bashrc.d/*; do
    if [ -r "${file}" ]; then
      . "${file}"
    fi
  done
  unset file
fi

# Add SSH keys to agent
if [ -x "${HOME}/.local/bin/loadkeys" ]; then
  if grep -qR "PRIVATE KEY" "${HOME}/.ssh/"; then
    "${HOME}/.local/bin/loadkeys"
  fi
fi

# vim: ft=sh ts=2 sts=2 sw=2 sr et
