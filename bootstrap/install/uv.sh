#!/usr/bin/env bash

set -euo pipefail

install_uv() {
  local uv_base_url="https://astral.sh/uv/install.sh"
  printf '[INFO] Installing uv\n'
  (
    export UV_NO_MODIFY_PATH=1
    curl \
      --silent \
      --show-error \
      --fail \
      --location \
      "${uv_base_url}" \
      | sh -s -- -y
  )
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

if ! install_uv_tools; then
    printf '[ERROR] Trouble installing uv tools!\n' >&2
    exit 1
fi

# vim: ft=sh ts=2 sts=2 sw=2 sr et
