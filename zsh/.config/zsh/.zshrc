# Performance profiling (uncomment to enable)
# zmodload zsh/zprof


# ------------------------------------------------------------
# Environment
# ------------------------------------------------------------

# Zsh completion cache
export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
export ZCOMPDUMP="${ZSH_CACHE_DIR}/completions/zcompdump"

# Load standard Zsh functions
autoload -Uz compaudit zmv zrecompile

# Initialize environment settings before loading plugins
if [[ -r "${ZDOTDIR}/lib/environment.zsh" ]]; then
  source "${ZDOTDIR}/lib/environment.zsh"
fi

# Load machine-specific environment settings
if [[ -r "${HOME}/.local/etc/shell/local.env" ]]; then
  source "${HOME}/.local/etc/shell/local.env"
fi


# ------------------------------------------------------------
# Shell Configuration
# ------------------------------------------------------------

# Load interactive aliases, functions, and integrations
shell_files=(
  "${HOME}/.config/shell/aliases.sh"
  "${HOME}/.config/shell/functions.sh"
  "${HOME}/.config/shell/fzf.sh"
  "${HOME}/.config/shell/ls.sh"
)

for file in "${shell_files[@]}"; do
  if [[ -r "${file}" ]]; then
    source "${file}"
  fi
done

unset shell_files file


# ------------------------------------------------------------
# Plugins
# ------------------------------------------------------------

# Load installed Zsh plugins
plugins=(direnv gpg-agent vi-mode)

for plugin in "${plugins[@]}"; do
  plugin_dir="${ZDOTDIR}/plugins/${plugin}"
  plugin_file="${plugin_dir}/${plugin}.plugin.zsh"

  if [[ -r "${plugin_file}" ]]; then
    # Add the plugin's functions directory only once
    (( ${fpath[(Ie)"${plugin_dir}"]} )) \
      || fpath=("${plugin_dir}" "${fpath[@]}")

    source "${plugin_file}"
  else
    printf '%s\n' "Plugin '${plugin}' not found"
  fi
done

unset plugins plugin plugin_dir plugin_file


# ------------------------------------------------------------
# Additional Configuration
# ------------------------------------------------------------

# Load remaining modules, excluding those loaded explicitly
for config_file in "${ZDOTDIR}"/lib/*.zsh(N); do
  case "${config_file:t}" in
    environment.zsh|ssh.zsh)
      continue
      ;;
  esac

  source "${config_file}"
done

unset config_file


# ------------------------------------------------------------
# Functions
# ------------------------------------------------------------

# Register custom functions for autoloading
if [[ -d "${ZDOTDIR}/functions" ]]; then
  for file in "${ZDOTDIR}"/functions/*(N.); do
    autoload -Uz "${file:t}"
  done
fi

unset file


# ------------------------------------------------------------
# Shell Options
# ------------------------------------------------------------

# Allow comments in interactive commands
setopt interactive_comments

# Display detailed job information
setopt long_list_jobs

# Handle combining Unicode characters
setopt combining_chars


# ------------------------------------------------------------
# ZLE
# ------------------------------------------------------------

# Prevent pasted commands from executing automatically
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic


# ------------------------------------------------------------
# Prompt
# ------------------------------------------------------------

# Enable prompt substitutions
setopt prompt_subst

# Load the custom prompt
if [[ -d "${ZDOTDIR}/prompts" ]]; then
  fpath=("${ZDOTDIR}/prompts" "${fpath[@]}")

  autoload -Uz prompt_chaz_setup
  prompt_chaz_setup
fi

# Display the virtual environment in Vim/Neovim terminals
if [[ -v VIMRUNTIME && -v VIRTUAL_ENV ]]; then
  PS1="${VIRTUAL_ENV_PROMPT}${PS1:-}"
  export PS1
fi


# ------------------------------------------------------------
# Node.js
# ------------------------------------------------------------

# Initialize Fast Node Manager
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd)"
fi


# ------------------------------------------------------------
# Yamlfix
# ------------------------------------------------------------

# Load yamlfix shell configuration
if [[ -r "${HOME}/.config/yamlfix/yamlfix" ]]; then
  source "${HOME}/.config/yamlfix/yamlfix"
fi


# ------------------------------------------------------------
# SSH
# ------------------------------------------------------------

# Initialize SSH key management
if [[ -r "${ZDOTDIR}/lib/ssh.zsh" ]]; then
  source "${ZDOTDIR}/lib/ssh.zsh"
fi


# Performance profiling output (uncomment to enable)
# zprof

# vim: ft=zsh ts=2 sts=2 sw=2 sr et
