#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
  pwd
)"

if ! command -v stow >/dev/null 2>&1; then
  printf '[ERROR] Requirement "stow" not found!\n' >&2
  exit 1
fi

mapfile -t stow_dotfiles < <(
  grep -vE '^\s*#|^\s*$' \
    "${REPO_ROOT}/bootstrap/config/stow-packages.conf"
)

for dotfile in "${stow_dotfiles[@]}"; do
  if [[ -d "${REPO_ROOT}/${dotfile}" ]]; then
    printf '[INFO] Stowing %s\n' "${dotfile}"
    stow \
      --verbose=1 \
      --dir="${REPO_ROOT}" \
      --target="${HOME}" \
      --restow \
      --no-folding \
      "${dotfile}"
    printf '\n'
  fi
done

# vim: ft=sh ts=2 sts=2 sw=2 sr et
