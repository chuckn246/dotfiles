#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
  pwd
)"

install_homebrew() {
  local homebrew_base_url="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
  local tmpdir

  printf '[INFO] Installing homebrew\n'

  tmpdir="$(mktemp -d)"
  trap 'rm -rf "'"${tmpdir}"'"' EXIT

  curl \
    --silent \
    --show-error \
    --fail \
    --location \
    --output "${tmpdir}/install.sh" \
    "${homebrew_base_url}"

  /bin/bash "${tmpdir}/install.sh"
}

# Homebrew's prefix (and therefore brew's own binary path) differs by
# architecture - /opt/homebrew on Apple Silicon, /usr/local on Intel.
# Hardcoding one silently breaks the other.
brew_prefix_for_arch() {
  case "$(uname -m)" in
    arm64) printf '/opt/homebrew' ;;
    x86_64) printf '/usr/local' ;;
    *) printf '[ERROR] Unsupported architecture: %s\n' "$(uname -m)" >&2; return 1 ;;
  esac
}

OS_NAME="$(uname)"
case "${OS_NAME}" in
    "Darwin")
      ;;
    "Linux")
      printf '[INFO] Linux detected -- skipping\n'
      exit 0
      ;;
    *)
      printf '[ERROR] Unsupported operating system: %s\n' "${OS_NAME}" >&2
      exit 1
      ;;
esac

if ! command -v brew >/dev/null 2>&1; then
  if ! command -v curl >/dev/null 2>&1; then
    printf '[ERROR] Missing dependency: curl\n' >&2
    exit 1
  fi

  if ! install_homebrew; then
      printf '[ERROR] Trouble installing homebrew!\n' >&2
      exit 1
  else
    brew_prefix="$(brew_prefix_for_arch)"
    eval "$("${brew_prefix}/bin/brew" shellenv)"
  fi
else
  printf '[INFO] brew already installed!\n'
fi

printf '[INFO] Installing Homebrew packages\n'
HOMEBREW_NO_ANALYTICS=1 \
HOMEBREW_REQUIRE_TAP_TRUST=1 \
brew bundle --file="${REPO_ROOT}/bootstrap/brew/Brewfile"

# vim: ft=sh ts=2 sts=2 sw=2 sr et
