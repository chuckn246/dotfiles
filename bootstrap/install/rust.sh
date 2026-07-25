#!/usr/bin/env bash

set -euo pipefail

install_rust() {
  local rust_download_url="https://sh.rustup.rs"

  printf '[INFO] Installing Rust\n'
  (
    export CARGO_HOME="${HOME}/.local/share/cargo"
    export RUSTUP_HOME="${HOME}/.local/share/rustup"
    curl \
      --silent \
      --show-error \
      --fail \
      --proto '=https' \
      --tlsv1.2 \
      "${rust_download_url}" \
      | sh -s -- --no-modify-path -y
  )
}

if command -v cargo >/dev/null 2>&1; then
  printf '[INFO] Rust already installed!\n'
  exit 0
fi

if ! command -v curl >/dev/null 2>&1; then
  printf '[ERROR] Missing dependency: curl\n' >&2
  exit 1
fi

if ! install_rust; then
  printf '[ERROR] Trouble installing Rust!\n' >&2
  exit 1
fi

# vim: ft=sh ts=2 sts=2 sw=2 sr et
