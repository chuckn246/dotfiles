zmodload -i zsh/complist

# Use hjlk in menu selection (during completion)
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

bindkey -M menuselect '^xg' clear-screen
bindkey -M menuselect '^xi' vi-insert                      # Insert
bindkey -M menuselect '^xh' accept-and-hold                # Hold
bindkey -M menuselect '^xn' accept-and-infer-next-history  # Next
bindkey -M menuselect '^xu' undo                           # Undo

# Completion options
_comp_options+=(globdots)
unsetopt menu_complete
setopt automenu auto_list complete_in_word
# setopt noautomenu nomenucomplete always_to_end

autoload -Uz compinit

# Load fzf completions
if ! (( $+functions[_fzf_complete] )); then
  FZF_DIR="${HOMEBREW_PREFIX}/opt/fzf/shell"
  [[ -r "$FZF_DIR/completion.zsh" ]] && source "$FZF_DIR/completion.zsh"
  [[ -r "$FZF_DIR/key-bindings.zsh" ]] && source "$FZF_DIR/key-bindings.zsh"
fi

# Zsh completion initialization
# - Fast startup via compinit -C
# - Rebuilds stale .zcompdump in the background
# - Prevents multiple tabs from rebuilding at the same time

# Lockfile to serialize background rebuilds
zcompdump_lock="${ZCOMPDUMP}.lock"

# Check if the dump is stale or missing
# - (#qN.mh+24) -> only matches if $ZCOMPDUMP modified in last 24h
# - -s "$ZCOMPDUMP.zwc" -> check if binary compiled dump exists
# - "$ZCOMPDUMP" -nt "$ZCOMPDUMP.zwc" -> rebuild if source newer than binary
if [[ -n "$ZCOMPDUMP"(#qN.mh+24) && (! -s "$ZCOMPDUMP.zwc" || "$ZCOMPDUMP" -nt "$ZCOMPDUMP.zwc") ]]; then
  # Fast startup: trust current dump even if stale
  compinit -C -d "$ZCOMPDUMP"
    # Background rebuild in a subshell
  {
    # Only one tab will succeed in creating the lock directory
    if mkdir "$zcompdump_lock" 2>/dev/null; then

      # Full rebuild of the .zcompdump file
      compinit -d "$ZCOMPDUMP"

      # Compile the dump to binary for faster future startups
      # -R = replace atomically
      # -- = end of options (safe if filename has dashes)
      zcompile -R -- "$ZCOMPDUMP"

      # Release the lock for other tabs
      rmdir "$zcompdump_lock"
    fi
  } &!  # &! = run in background, suppress job control messages
else
  # If dump is fresh, just trust it (fastest path)
  compinit -C -d "$ZCOMPDUMP"
fi

# Defaults
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR

# case insensitive (all), partial-word and substring completion
if [[ "${CASE_SENSITIVE:-false}" == true ]]; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  setopt CASE_GLOB
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unsetopt CASE_GLOB
fi

# Group matches and describe
zstyle ':completion:*:*:*:*:*' menu select interactive
zstyle ':completion:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# Matching
# zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*:commands' completer _complete _approximate
zstyle ':completion:*' completer _extensions _complete
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Complete the alias when _expand_alias is used as a function
zstyle ':completion:*' complete true

# Autocomplete options for cd instead of directory stack
zstyle ':completion:*' complete-options true

# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
#zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
# Expand // to /
zstyle ':completion:*' squeeze-slashes true
#zstyle ':completion:*' file-sort modification
#zstyle ':completion:*' file-list all

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Expand aliases each time you hit CTRL+a
#zle -C alias-expension complete-word _generic
#bindkey '^Xa' alias-expension
#zstyle ':completion:alias-expension:*' completer _expand_alias

# Required for completion to be in good groups (named after the tags)
zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands
zstyle ':completion:*' keep-prefix true

setup_ssh_hosts() {
  local includes hosts_from_config hosts_from_includes hosts_from_known all_hosts

  # Parse Include directives in ~/.ssh/config
  includes=(${=${${${${(@M)${(f)"$(<~/.ssh/config 2>/dev/null)"}:#Include *}#Include }:#*\**}:#*\?*}})
  hosts_from_config=(${=${${${${(@M)${(f)"$(<~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}})
  hosts_from_includes=(${=${${${${(@M)${(f)"$(<~/.ssh/${^includes} 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}})
  hosts_from_known=(${=${=${=${${(f)"$(<{/etc/ssh/ssh_,~/.ssh/}known_hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ })
  all_hosts=(${hosts_from_config[@]} ${hosts_from_includes[@]} ${hosts_from_known[@]})

  reply=(${all_hosts[@]})
}

# Lazy evaluation for :completion:*:hosts
zstyle -e ':completion:*:hosts' hosts 'setup_ssh_hosts'

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'

# ... unless we really want to.
zstyle '*' single-ignored show

# Ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

#  Processes
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# SSH/SCP/RSYNC
zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:ssh:*' group-order users hosts-host hosts-domain hosts-ipaddr
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-host hosts-domain hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# Enable bash-style completion functions in zsh (only when needed)
if ! (( $+functions[bashcompinit] )); then
  autoload -U +X bashcompinit && bashcompinit
fi

# AWS CLI completions
if command -v aws_completer >/dev/null 2>&1; then
  complete -C aws_completer aws
  complete -C aws_completer awslocal
fi

# Terraform completions
 if command -v terraform >/dev/null 2>&1; then
  complete -o nospace -C terraform terraform
  complete -o nospace -C terraform tf
 fi

# Terragrunt completions
if  command -v terragrunt >/dev/null 2>&1; then
  complete -o nospace -C terragrunt
  complete -o nospace -C tg
fi

# vim: ft=zsh ts=2 sts=2 sw=2 nosr et
