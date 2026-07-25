#!/usr/bin/env bash

set -euo pipefail

install_podman() {
  local os_arch
  local podman_base_download_url
  local podman_file_name
  local tmpdir

  os_arch="$(uname -m)"
  case "${os_arch}" in
      "arm64") true ;;
      "x86_64") true ;;
      *) printf 'Unsupported architecture: %s\n' >&2 "${os_arch}" && return 1 ;;
  esac

  podman_file_name="podman-installer-macos-${os_arch}.pkg"

  printf '[INFO] Downloading Podman...\n'
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "'"${tmpdir}"'"' EXIT

  curl \
    --silent \
    --show-error \
    --location \
    --output "${tmpdir}/shasums" \
    "${podman_base_download_url}/shasums"

  curl \
    --silent \
    --show-error \
    --location \
    --output "${tmpdir}/${podman_file_name}" \
    "${podman_base_download_url}/${podman_file_name}"

  printf '[INFO] Validating Podman...\n'
  if ! ( cd "${tmpdir}"; shasum --ignore-missing -c shasums ); then
    printf '[ERROR] Verification failed!\n' >&2
    return 1
  fi

  printf '[INFO] Installing Podman...\n'
  sudo installer \
      -pkg "${tmpdir}/${podman_file_name}" \
      -target /

  if ! podman machine inspect podman-machine-default >/dev/null 2>&1; then
    podman machine init podman-machine-default
  fi

  podman machine start
  podman machine ssh podman-machine-default \
    "rpm-ostree install vim --assumeyes --idempotent"
  podman machine ssh podman-machine-default \
    '
    grep -qxF "set -o vi" ~/.bashrc ||
    printf "\nset -o vi\n" >> ~/.bashrc
    '
}

if command -v podman >/dev/null 2>&1; then
    printf '[INFO] Podman already installed!\n'
    exit 0
fi

printf 'Install and initialize Podman?\n'
PS3="Choice: "
select choice in "yes" "no"; do
  case "${choice}" in
    "yes") break ;;
    "no") printf '[INFO] Exiting without installing\n' && exit 0 ;;
  esac
done

for cmd in curl shasum installer; do
  if ! command -v "${cmd}" >/dev/null; then
    printf '[ERROR] Missing dependency: %s\n' "${cmd}" >&2
    exit 1
  fi
done

if ! install_podman; then
    printf '[ERROR] Trouble installing Podman!\n' >&2
    exit 1
fi

# vim: ft=sh ts=2 sts=2 sw=2 sr et
