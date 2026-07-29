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

# stow refuses to symlink over a real (non-symlink) file, by design - it
# won't silently clobber existing content. Fresh systems commonly have
# OS-default dotfiles already in place (e.g. Debian's /etc/skel-seeded
# ~/.bashrc for root) which trip this. Back conflicting real files up
# out of the way rather than deleting them outright, so nothing is lost
# if the "default" file actually had something worth keeping.
backup_real_file_conflicts() {
  local package="$1"
  local backup_dir="${HOME}/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
  local target_path

  # `stow --simulate` reports what it WOULD do without touching anything -
  # parse its conflict warnings to find real-file collisions up front,
  # rather than reacting after a failed restow.
  while IFS= read -r line; do
    if [[ "${line}" =~ existing\ target\ (.+)\ since ]]; then
      target_path="${HOME}/${BASH_REMATCH[1]}"
      if [[ -e "${target_path}" && ! -L "${target_path}" ]]; then
        mkdir -p "${backup_dir}"
        printf '[WARN] Backing up existing %s -> %s\n' "${target_path}" "${backup_dir}/"
        mv "${target_path}" "${backup_dir}/"
      fi
    fi
  done < <(
    stow \
      --simulate \
      --verbose=1 \
      --dir="${REPO_ROOT}" \
      --target="${HOME}" \
      --restow \
      --no-folding \
      "${package}" 2>&1 || true
  )
}

for dotfile in "${stow_dotfiles[@]}"; do
  if [[ -d "${REPO_ROOT}/${dotfile}" ]]; then
    printf '[INFO] Stowing %s\n' "${dotfile}"

    backup_real_file_conflicts "${dotfile}"

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
