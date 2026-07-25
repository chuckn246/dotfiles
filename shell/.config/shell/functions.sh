#!/usr/bin/env bash

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf '[ERROR] %s: command not found\n' "$1" >&2
    return 1
  fi
}

avc() {
  require_command ansible-vault || return
  ansible-vault encrypt "$@"
}

avd() {
  require_command ansible-vault || return
  ansible-vault decrypt "$@"
}

ave() {
  require_command ansible-vault || return
  ansible-vault edit "$@"
}

avv() {
  require_command ansible-vault || return
  ansible-vault view "$@"
}


crtchk() {
  local url website

  if [[ $# -ge 1 ]]; then
    url="${1}"
  else
    printf 'URL: '
    read -r url
  fi

  if [[ -z "${url}" ]]; then
    printf '[ERROR] No URL provided.\n' >&2
    return 2
  fi

  # Accept hostname or URL: example.com, https://example.com/path, example.com:8443
  website="${url#*://}"
  website="${website%%/*}"

  # if command -v nmap >/dev/null 2>&1; then
  #   nmap -p 443 --script ssl-cert "${website}"

  if command -v openssl >/dev/null 2>&1; then
    openssl s_client \
      -connect "${website}:443" \
      -servername "${website}" \
      </dev/null 2>/dev/null |
      openssl x509 -noout -subject -issuer -dates -ext subjectAltName

  elif command -v curl >/dev/null 2>&1; then
    curl --insecure -vvI "https://${website}" 2>&1 |
      awk 'BEGIN { cert = 0 }
        /^\* SSL connection/ { cert = 1 }
        /^\*/ && cert { print }'

  else
    printf '[ERROR} Neither nmap, openssl, nor curl are available.\n' >&2
    return 1
  fi
}

# Show Git status for repositories below the current directory.
# Handles plain repos and "bare + worktrees" layouts.
gitchk() {
  local dir subdir header_printed
  while IFS= read -r dir; do
    if git -C "${dir}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      printf '>>> %s (repo)\n' "${dir}"
      if ! GIT_SSH_COMMAND="ssh -q -o BatchMode=yes" \
        git -C "${dir}" fetch --quiet </dev/null; then
          printf '  !! fetch failed, status below may be stale\n'
      fi
      git -C "${dir}" status -uno
      printf '\n'
      continue
    fi

    # Not a repo on its own -- could be a container: a bare repo +
    # worktrees, OR a non-bare "main" checkout + linked worktrees
    header_printed=false
    while IFS= read -r subdir; do
      git -C "${subdir}" rev-parse --is-inside-work-tree >/dev/null 2>&1 || continue

      if [[ "${header_printed}" == false ]]; then
        printf '>>> %s (worktree parent)\n' "${dir}"
        header_printed=true
      fi

      printf '  -> %s\n' "${subdir}"
      if ! GIT_SSH_COMMAND="ssh -q -o BatchMode=yes" \
        git -C "${subdir}" fetch --quiet </dev/null; then
          printf '    !! fetch failed, status below may be stale\n'
      fi
      git -C "${subdir}" status -uno
      printf '\n'
    done < <(find "${dir}" -mindepth 1 -maxdepth 1 -type d | sort)
  done < <(find . -mindepth 1 -maxdepth 1 -type d | sort)
}

# vim: ft=sh ts=2 sts=2 sw=2 sr et
