#!/usr/bin/env bash

set -euo pipefail

: "${XDG_DATA_HOME:=${HOME}/.local/share}"
: "${XDG_BIN_HOME:=${HOME}/.local/bin}"

# Explicit rather than relying on uv's implicit default - keeps this
# script (and any dotfile snippet) referring to a known location instead
# of guessing where the installer decided to put things.
export UV_INSTALL_DIR="${XDG_BIN_HOME}"
export UV_TOOL_BIN_DIR="${XDG_BIN_HOME}"
export UV_TOOL_DIR="${XDG_DATA_HOME}/uv/tools"

install_uv() {
  local uv_base_url="https://astral.sh/uv/install.sh"
  printf '[INFO] Installing uv\n'
  export UV_NO_MODIFY_PATH=1
  curl \
    --silent \
    --show-error \
    --fail \
    --location \
    "${uv_base_url}" \
    | sh -s --

  # UV_NO_MODIFY_PATH=1 means the installer deliberately won't touch PATH -
  # that's correct for dotfiles (we wire it in ourselves, deliberately,
  # same pattern as perl/fnm/rust), but this script's OWN remaining steps
  # (install_uv_tools, right below) still need `uv` callable NOW. This
  # export is scoped to this script's process only - it does not persist
  # to future shells.
  export PATH="${UV_INSTALL_DIR}:${PATH}"
}

install_uv_tools() {
  local uv_tools=(
    ansible-lint
    argcomplete
    cfn-lint
    isort
    j2lint
    pygments
    pytest
    ruff
    ty
    yamlfix
    yamllint
    yt-dlp
  )

  for tool in "${uv_tools[@]}"; do
    printf '[INFO] Installing %s\n' "${tool}"
    uv tool install "${tool}"
  done
}

if ! command -v uv >/dev/null 2>&1; then
  if ! command -v curl >/dev/null 2>&1; then
    printf '[ERROR] Missing dependency: curl\n' >&2
    exit 1
  fi

  if ! install_uv; then
      printf '[ERROR] Trouble installing uv!\n' >&2
      exit 1
  fi
else
  printf '[INFO] uv already installed\n'
fi

command -v uv >/dev/null 2>&1 || {
  printf '[ERROR] uv still not found after install. Something went wrong.\n' >&2
  exit 1
}

if ! install_uv_tools; then
    printf '[ERROR] Trouble installing uv tools!\n' >&2
    exit 1
fi

printf '[INFO] uv: %s\n' "$(uv --version)"

cat <<EOF

[INFO] Wire this up permanently in two places:

  1. ~/.config/shell/environment.sh   (pure vars, no PATH dependency)

       export UV_TOOL_DIR="${UV_TOOL_DIR}"
       export UV_TOOL_BIN_DIR="${UV_TOOL_BIN_DIR}"

  2. your shell's login-profile file  (PATH-dependent)

       export PATH="${XDG_BIN_HOME}:\${PATH}"

Then open a NEW terminal window and verify with: uv --version && ansible-lint --version

EOF

# vim: ft=sh ts=2 sts=2 sw=2 sr et
