#!/usr/bin/env bash
# install-node-xdg.sh - install fnm + Node LTS, wire npm/node to XDG dirs
set -euo pipefail

: "${XDG_DATA_HOME:=${HOME}/.local/share}"
: "${XDG_CACHE_HOME:=${HOME}/.cache}"
: "${XDG_CONFIG_HOME:=${HOME}/.config}"
: "${XDG_STATE_HOME:=${HOME}/.local/state}"

REPO_ROOT="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
  pwd
)"

PACKAGES_FILE="${REPO_ROOT}/bootstrap/config/npm-packages.conf"
FNM_DIR="${XDG_DATA_HOME}/fnm"
export FNM_DIR

printf '%s\n' "[INFO] Installing Node tooling"

# fnm has no apt package on Debian/Ubuntu - the only supported
# non-Homebrew install path is its own installer script. We scope it
# to our XDG dir and skip its shell-rc modification (--skip-shell) so
# it doesn't write anything into your dotfiles behind your back - you
# add the PATH line yourself, deliberately, same spirit as the perl setup.
if ! command -v fnm >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    printf '%s\n' "[INFO] Installing fnm via Homebrew..."
    brew install fnm
  else
    printf '%s\n' "[INFO] No Homebrew - installing fnm via official installer into ${FNM_DIR}..."
    curl -fsSL https://fnm.vercel.app/install | bash -s -- \
      --install-dir "${FNM_DIR}" \
      --skip-shell
    export PATH="${FNM_DIR}:${PATH}"
    printf '%s\n' "[WARN] Add ${FNM_DIR} to PATH in your shell config - not done automatically."
  fi
fi

command -v fnm >/dev/null 2>&1 || {
  printf '%s\n' "[ERROR] fnm still not on PATH after install. Add ${FNM_DIR} to PATH and re-run." >&2
  exit 1
}

# fnm env normally autodetects the calling shell by walking the process
# tree - that detection can fail when run non-interactively (e.g. via
# ./node.sh rather than a login/interactive shell), silently producing
# no output and leaving PATH unset. Pass --shell explicitly so this
# always works regardless of how the script is invoked.
FNM_ENV_OUTPUT="$(fnm env --shell bash)"
if [[ -z "${FNM_ENV_OUTPUT}" ]]; then
  printf '%s\n' "[ERROR] 'fnm env' produced no output - cannot continue." >&2
  exit 1
fi
eval "${FNM_ENV_OUTPUT}"

# fnm install --lts is idempotent - it no-ops if the resolved LTS version is present
fnm install --lts
fnm default lts-latest

NODE_VERSION="$(node --version)"
printf '%s\n' "[INFO] Node ${NODE_VERSION}"

# NOTE: deliberately NOT setting NPM_CONFIG_PREFIX/npm_config_prefix here.
# fnm already isolates global npm packages per-Node-version under
# ${FNM_DIR}/node-versions/<version>/installation/lib/node_modules.
# Overriding the prefix would make every Node version share one global
# node_modules dir, defeating fnm's version isolation - so global `npm i -g`
# installs intentionally stay wherever fnm puts them, not under XDG_DATA_HOME.
NPM_CACHE="${XDG_CACHE_HOME}/npm"
NPM_CONFIG_DIR="${XDG_CONFIG_HOME}/npm"
NODE_STATE_DIR="${XDG_STATE_HOME}/node"

export NPM_CONFIG_CACHE="${NPM_CACHE}"
export NPM_CONFIG_USERCONFIG="${NPM_CONFIG_DIR}/npmrc"
export NODE_REPL_HISTORY="${NODE_STATE_DIR}/repl_history"

mkdir -p "${NPM_CACHE}" "${NPM_CONFIG_DIR}" "${NODE_STATE_DIR}"

# Fail fast with a clear message rather than an unbound-variable crash
# or a confusing error from inside the read loop below.
: "${PACKAGES_FILE:?Set PACKAGES_FILE to the path of your global-packages list}"
[ -r "${PACKAGES_FILE}" ] || {
  printf '%s\n' "[ERROR] PACKAGES_FILE '${PACKAGES_FILE}' not found or not readable." >&2
  exit 1
}

# Install global modules
while IFS= read -r package; do
  case "${package}" in
    ""|\#*) continue ;;
  esac

  if npm list --global --depth=0 "${package}" >/dev/null 2>&1; then
    printf '%s\n' "[OK] ${package} already installed"
  else
    printf '%s\n' "[INSTALL] ${package}"
    npm install --global "${package}"
  fi
done < "${PACKAGES_FILE}"

printf '%s\n' "[INFO] npm installation complete"

# environment.sh gets pure vars (no PATH dependency, safe to always load).
# .zprofile gets PATH-dependent bits - fnm's own binary location (Linux
# only; brew's shellenv already covers it on macOS) and the `fnm env`
# eval, which must run after fnm itself is resolvable
if command -v brew >/dev/null 2>&1; then
  cat <<EOF

[INFO] Wire this up permanently in two places:

  1. ~/.config/shell/environment.sh   (pure vars, no PATH dependency)

       export FNM_DIR="${FNM_DIR}"
       export NPM_CONFIG_CACHE="${NPM_CACHE}"
       export NPM_CONFIG_USERCONFIG="${NPM_CONFIG_DIR}/npmrc"
       export NODE_REPL_HISTORY="${NODE_STATE_DIR}/repl_history"

  2. your shell's login-profile file (PATH-dependent - must come after
     'brew shellenv', since fnm itself needs to be resolvable first)

       eval "\$(fnm env)"

Then open a NEW terminal window and verify with: node --version

EOF
else
  cat <<EOF

[INFO] Wire this up permanently in two places:

  1. ~/.config/shell/environment.sh   (pure vars, no PATH dependency)

       export FNM_DIR="${FNM_DIR}"
       export NPM_CONFIG_CACHE="${NPM_CACHE}"
       export NPM_CONFIG_USERCONFIG="${NPM_CONFIG_DIR}/npmrc"
       export NODE_REPL_HISTORY="${NODE_STATE_DIR}/repl_history"

  2. your shell's login-profile file   (PATH-dependent - fnm's own binary
     lives directly in FNM_DIR here, nothing else puts it on PATH)

       export PATH="${FNM_DIR}:\${PATH}"
       eval "\$(fnm env)"

Then open a NEW terminal window and verify with: node --version

EOF
fi

# vim: ft=sh ts=2 sts=2 sw=2 sr et
