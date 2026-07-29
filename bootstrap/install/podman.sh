#!/usr/bin/env bash

set -euo pipefail

install_podman_macos() {
  local os_arch
  local podman_arch
  local podman_base_download_url="https://github.com/containers/podman/releases/latest/download"
  local podman_file_name
  local tmpdir

  os_arch="$(uname -m)"
  # podman's macOS release filenames use aarch64/amd64, not uname's
  # arm64/x86_64 - same mismatch pattern as the Go script's go_arch mapping.
  case "${os_arch}" in
      "arm64") podman_arch="aarch64" ;;
      "x86_64") podman_arch="amd64" ;;
      *) printf '[ERROR] Unsupported architecture: %s\n' "${os_arch}" >&2 && return 1 ;;
  esac

  podman_file_name="podman-installer-macos-${podman_arch}.pkg"

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

install_podman_linux() {
  # Linux runs podman natively against the kernel - there's no VM to
  # init/start/ssh into, so none of the macOS "podman machine" logic
  # applies here. uidmap + slirp4netns are typical prerequisites for
  # rootless podman (user namespace mapping, rootless networking) -
  # without them, `podman run` as a non-root user commonly fails on
  # a confusing namespace error the first time it's used.
  printf '[INFO] Installing Podman via apt...\n'
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends podman uidmap slirp4netns
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

os_name="$(uname)"
case "${os_name}" in
  "Darwin")
    required_cmds=(curl shasum installer)
    ;;
  "Linux")
    required_cmds=(curl)
    ;;
  *)
    printf '[ERROR] Unsupported OS: %s\n' "${os_name}" >&2
    exit 1
    ;;
esac

for cmd in "${required_cmds[@]}"; do
  if ! command -v "${cmd}" >/dev/null; then
    printf '[ERROR] Missing dependency: %s\n' "${cmd}" >&2
    exit 1
  fi
done

if [[ "${os_name}" == "Darwin" ]]; then
  if ! install_podman_macos; then
    printf '[ERROR] Trouble installing Podman!\n' >&2
    exit 1
  fi
else
  if ! install_podman_linux; then
    printf '[ERROR] Trouble installing Podman!\n' >&2
    exit 1
  fi
fi

command -v podman >/dev/null 2>&1 || {
  printf '[ERROR] podman not found on PATH after install.\n' >&2
  exit 1
}

printf '[INFO] Podman installed: %s\n' "$(podman --version)"

# vim: ft=sh ts=2 sts=2 sw=2 sr et
