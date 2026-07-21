HISTFILE="$HOME/.local/state/zsh/history"
HISTSIZE=200000
SAVEHIST=200000
export HISTFILE HISTSIZE SAVEHIST

alias h="fc -li 1"

# Ensure history dir exists
mkdir -p -- "${HISTFILE:h}"

# History command configuration
setopt extended_history       # store timestamps + durations
setopt append_history         # don't overwrite history file
setopt inc_append_history     # write history incrementally (better multi-shell)
setopt hist_fcntl_lock        # safer concurrent writes

unsetopt share_history         # avoid live-merging weirdness

setopt hist_ignore_space      # ignore commands that start with space
setopt hist_reduce_blanks     # trim extra internal whitespace
setopt hist_verify            # show command with history expansion to user before running it

setopt hist_find_no_dups      # skip dupes when searching
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE

# vim: ft=zsh ts=2 sts=2 sw=2 sr et
