# XDG Base Directory
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

# CURL
export CURL_HOME="${XDG_CONFIG_HOME}/curl"

# EDITOR
if command -v nvim >/dev/null 2>&1; then
    export EDITOR=nvim
elif command -v vim >/dev/null 2>&1; then
    export EDITOR=vim
else
    export EDITOR=vi
fi
export VISUAL="${EDITOR}"
export SUDO_EDITOR="${EDITOR}"

# GO
export GOPATH="${XDG_DATA_HOME}/go"

# LESS
LESS='-F -i -R -Q -J -M -W -X -x4 -z-4'
if less --mouse </dev/null >/dev/null 2>&1; then
  LESS="--mouse ${LESS}"
fi
export LESS
export PAGER=less

if command -v lessfile >/dev/null 2>&1; then
  eval "$(lessfile)"
else
  export LESSOPEN="| ~/.lessfilter %s"
fi

# LS
if [ -r "${XDG_CONFIG_HOME}/shell/less.sh" ]; then
  . "${XDG_CONFIG_HOME}/shell/less.sh"
fi

# MYSQL
export MYSQL_HISTFILE="${XDG_STATE_HOME}/mysql/history"

# NETWORK
#if [ -f "${HOME}/.hosts" ]; then
#  export HOSTFILE="${HOME}/.hosts"
#fi

# NODE
export FNM_DIR="${XDG_DATA_HOME}/fnm"
export NODE_REPL_HISTORY="${XDG_STATE_HOME}/node/repl_history"
export NPM_CONFIG_CACHE="${XDG_CACHE_HOME}/npm"
export NPM_CONFIG_PREFIX="${XDG_DATA_HOME}/npm"
export NPM_CONFIG_PREFIX="${XDG_DATA_HOME}/npm"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"

# PERL - cpanm build logs, tarball cache
export PERL_CPAN_HOME="${XDG_CACHE_HOME}/cpan"
export PERL_CPANM_HOME="${XDG_CACHE_HOME}/cpanm"

# PSQL
export PSQL_HISTORY="${XDG_STATE_HOME}/psql/history"

# PYTHON
export PYTHON_HISTORY="${XDG_STATE_HOME}/python/history"

# RANGER
if command -v ranger >/dev/null 2>&1; then
  export RANGER_LOAD_DEFAULT_RC=FALSE
fi

# REDIS
export REDISCLI_HISTFILE="${XDG_STATE_HOME}/redis/history"

# RIPGREP
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/ripgreprc"

# RUST
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"

# SQLITE
export SQLITE_HISTORY="${XDG_STATE_HOME}/sqlite/history"

# SYSTEMD
if command -v journalctl >/dev/null 2>&1; then
  export SYSTEMD_LESS="${LESS}"
fi

# UV
export UV_NO_MODIFY_PATH=1

# VALKEY
export VALKEYCLI_HISTFILE="${XDG_STATE_HOME}/valkey/history"

# vim: ft=sh ts=2 sts=2 sw=2 sr et
