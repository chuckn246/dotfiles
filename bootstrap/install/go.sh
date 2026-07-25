#!/usr/bin/env bash

set -euo pipefail

install_go() {
  local os_name
  local os_arch
  local go_kind
  local go_version
  local go_data
  local go_file_name
  local go_file_hash
  local local_hash
  local base_go_url
  local base_go_download_url
  local tmpdir

  base_go_url="https://go.dev"
  base_go_download_url="${base_go_url}/dl"
  os_name="$(uname)"
  os_arch="$(uname -m)"

  case "${os_name}" in
    "Darwin")
      go_kind="installer"
      ;;
    *)
      printf '[ERROR] Unsupported OS: %s\n' "${os_name}" >&2
      return 1
      ;;
  esac

  case "${os_arch}" in
    arm64)
        go_arch=arm64
        ;;
    x86_64)
        go_arch=amd64
        ;;
    *)
        printf '[ERROR] Unsupported architecture: %s \n' "${os_arch}" >&2
        return 1
        ;;
  esac

  go_version=$(curl --silent "${base_go_url}/VERSION?m=text" | head -n1)
  go_data=$(curl --silent "${base_go_download_url}/?mode=json" \
    | jq --raw-output \
        --arg GO_OS "${os_name,,}" \
        --arg GO_ARCH "${go_arch}" \
        --arg GO_KIND "${go_kind}" \
        --arg GO_VERSION "${go_version}" \
        '.[].files[] | select(
                        .os == $GO_OS and
                        .kind == $GO_KIND and
                        .arch == $GO_ARCH and
                        .version == $GO_VERSION
                        ) | "\(.filename)\t\(.sha256)"'
  )

  if [[ -z "${go_data}" ]]; then
    printf '[ERROR] Unable to locate Go download metadata.\n' >&2
    return 1
  else
    IFS=$'\t' read -r go_file_name go_file_hash <<< "${go_data}"
  fi

  printf '[INFO] Downloading %s...\n' "${go_file_name}"
  tmpdir="$(mktemp -d)"
  go_file_name="${tmpdir}/${go_file_name}"
  trap 'rm -rf "'"${tmpdir}"'"' EXIT
  curl --silent \
    --show-error \
    --location \
    --output "${go_file_name}" \
    "${base_go_download_url}/${go_file_name}"

  printf '[INFO] Verifying checksum...\n'
  local_hash=$(shasum -a 256 "${go_file_name}" | cut -d' ' -f1)
  if [[ "${go_file_hash}" != "${local_hash}" ]]; then
    printf '[ERROR] SHA256 verification failed.\n' >&2
    printf '[ERROR] Expected: %s\n' "${go_file_hash}" >&2
    printf '[ERROR] Actual:   %s\n' "${local_hash}" >&2
    return 1
  fi

  printf '[INFO] Installing Go %s...\n' "${go_version}"
  sudo installer \
    -pkg "${go_file_name}" \
    -target /
}

if command -v go >/dev/null 2>&1; then
  printf '[INFO] Go already installed!\n'
  exit 0
fi

for cmd in curl jq shasum installer; do
  if ! command -v "${cmd}" >/dev/null; then
    printf '[ERROR] Missing dependency: %s\n' "${cmd}" >&2
    exit 1
  fi
done

if ! install_go; then
    printf '[ERROR] Trouble installing Go!\n' >&2
    exit 1
fi

# vim: ft=sh ts=2 sts=2 sw=2 sr et
