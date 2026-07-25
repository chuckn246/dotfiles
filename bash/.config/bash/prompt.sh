# Git prompt support
for git_prompt in \
    "$(brew --prefix 2>/dev/null)/etc/bash_completion.d/git-prompt.sh" \
    /usr/share/git/completion/git-prompt.sh \
    /usr/lib/git-core/git-sh-prompt
do
    if [ -r "${git_prompt}" ]; then
        . "${git_prompt}"
        break
    fi
done
unset git_prompt

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUPSTREAM=auto

# # Prompt
# PS1='['
# PS1+='\u@\h:\W'
# PS1+=']'
# PS1+='$(__git_ps1 "(%s)")'
# PS1+='\$ '

# Colors (only if stdout is a terminal with color support)
if [ -t 1 ] && command -v tput >/dev/null 2>&1 &&
   [ "$(tput colors 2>/dev/null || printf '0')" -ge 8 ]; then
    c_reset='\[\e[0m\]'

    c_user='\[\e[1;34m\]'
    c_host='\[\e[1;34m\]'
    c_path='\[\e[1;33m\]'
    c_git='\[\e[1;35m\]'

    # Highlight root
    if [ "${EUID}" -eq 0 ]; then
        c_user='\[\e[1;31m\]'
    fi

    # Highlight SSH sessions
    if [ -n "${SSH_CONNECTION}" ]; then
        c_host='\[\e[1;33m\]'
    fi
else
    c_reset=''
    c_user=''
    c_host=''
    c_path=''
    c_git=''
fi

# Window title (xterm, Terminal.app, iTerm2, etc.)
case "${TERM}" in
    xterm*|rxvt*|screen*|tmux*)
        PS1='\[\e]0;\u@\h: \w\a\]'
        ;;
    *)
        PS1=''
        ;;
esac

# Main prompt
PS1+="${c_user}[\u${c_reset}@${c_host}\h${c_reset}:${c_path}\W${c_reset}]"
PS1+="${c_git}\$(__git_ps1 '(%s)')${c_reset}"
PS1+="\\$ "

unset c_reset c_user c_host c_path c_git

# ft=bash ts=2 sts=2 sw=2 sr et
