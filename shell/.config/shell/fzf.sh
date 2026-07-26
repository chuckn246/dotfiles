# FZF
# Setup
if command -v fzf >/dev/null 2>&1; then
  DISABLE_FZF_AUTO_COMPLETION="false"
  DISABLE_FZF_KEY_BINDINGS="false"

  # Default options
  FZF_DEFAULT_COMMAND='rg --files --hidden --glob !.git/\*'
  FZF_DEFAULT_OPTS="--height=40% --layout=reverse --info=inline --border --margin=1 --padding=1 --tmux=bottom,80%,40%"
  FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --bind alt-j:page-down,alt-k:page-up"
  FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS},ctrl-alt-k:preview-up,ctrl-alt-j:preview-down"
  FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS},ctrl-alt-u:preview-half-page-up,ctrl-alt-d:preview-half-page-down"
  FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS},ctrl-alt-b:preview-page-up,ctrl-alt-f:preview-page-down"
  FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS},ctrl-alt-h:preview-top,ctrl-alt-g:preview-bottom"

  # cd list options
  FZF_ALT_C_COMMAND="find * -mindepth 1 -maxdepth 2 -type d | sort"
  FZF_ALT_C_OPTS="--preview 'tree -C {} 2> /dev/null | head -200'"

  # History options
  FZF_CTRL_R_OPTS="--no-sort --padding=0,1,1 --color header:italic --exact"
  FZF_CTRL_R_OPTS="${FZF_CTRL_R_OPTS} --header-first --header-border=double"
  FZF_CTRL_R_OPTS="${FZF_CTRL_R_OPTS} --header 'Press CTRL+Y to copy command into clipboard'"
  # FZF_CTRL_R_OPTS="${FZF_CTRL_R_OPTS} --preview 'echo {}' --preview-window down:20%:hidden:wrap"
  # FZF_CTRL_R_OPTS="${FZF_CTRL_R_OPTS} --bind '?:toggle-preview'"
  FZF_CTRL_R_OPTS="${FZF_CTRL_R_OPTS} --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"

  # File list options
  FZF_CTRL_T_COMMAND="find . -mindepth 1 -maxdepth 1 | cut -d'/' -f2 | sort"
  FZF_CTRL_T_OPTS="--prompt 'All> ' --header 'CTRL-D: Directories / CTRL-F: Files'"
  FZF_CTRL_T_OPTS="${FZF_CTRL_T_OPTS} --bind 'ctrl-d:change-prompt(Directories> )+reload(find . -mindepth 1 -maxdepth 1 -type d | cut -d'/' -f2)'"
  FZF_CTRL_T_OPTS="${FZF_CTRL_T_OPTS} --bind 'ctrl-f:change-prompt(Files> )+reload(find . -mindepth 1 -maxdepth 1 -type f | cut -d'/' -f2)'"
  FZF_CTRL_T_OPTS="${FZF_CTRL_T_OPTS} --preview '(bat {} || tree -C {}) 2> /dev/null | head -200'"

  export FZF_DEFAULT_COMMAND FZF_ALT_C_COMMAND FZF_CTRL_T_COMMAND
  export FZF_DEFAULT_OPTS FZF_ALT_C_OPTS FZF_CTRL_R_OPTS FZF_CTRL_T_OPTS
  export DISABLE_FZF_AUTO_COMPLETION DISABLE_FZF_KEY_BINDINGS
fi

# vim: ft=sh ts=2 sts=2 sw=2 sr et
