#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

printf '[INFO] Creating directories\n'
while IFS= read -r directory; do
  # Remove leading/trailing whitespace and skip empty lines or comments
  directory=$(echo "${directory}" | xargs)
  [[ -z "${directory}" || "${directory}" =~ ^# ]] && continue

  # Define the full absolute target path
  target_dir="${HOME}/${directory}"

  if [[ ! -d "${target_dir}" ]]; then
    printf '[INFO] Creating %s\n' "${target_dir}"
    install -d \
      -o "$(id -u)" \
      -g "$(id -g)" \
      -m 0750 \
      "${target_dir}"
  fi
done < "${REPO_ROOT}/bootstrap/config/home-directories.conf"

printf '[INFO] Running Homebrew configuration\n'
"${REPO_ROOT}/bootstrap/install/homebrew.sh"

printf '[INFO] Running UV configuration\n'
"${REPO_ROOT}/bootstrap/install/uv.sh"

printf '[INFO] Running Go configuration\n'
"${REPO_ROOT}/bootstrap/install/go.sh"

printf '[INFO] Running Rust configuration\n'
"${REPO_ROOT}/bootstrap/install/rust.sh"

# printf '[INFO] Running Podman configuration\n'
# "${REPO_ROOT}/bootstrap/install/podman.sh"

printf '[INFO] Running Stow configuration\n'
"${REPO_ROOT}/bootstrap/install/stow.sh"

# vim: ft=sh ts=2 sts=2 sw=2 sr et
