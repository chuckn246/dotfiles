#!/usr/bin/env bash

set -euo pipefail

: "${XDG_DATA_HOME:=${HOME}/.local/share}"

export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"

install_rust() {
  local rust_download_url="https://sh.rustup.rs"

  printf '[INFO] Installing Rust\n'
  curl \
    --silent \
    --show-error \
    --fail \
    --proto '=https' \
    --tlsv1.2 \
    "${rust_download_url}" \
    | sh -s -- --no-modify-path -y
}

verify_default_toolchain() {
  if ! "${CARGO_HOME}/bin/rustc" --version >/dev/null 2>&1; then
    printf '[WARN] No default toolchain detected after install — setting one explicitly.\n'
    "${CARGO_HOME}/bin/rustup" default stable
  fi
}

ensure_linker() {
  if ! command -v cc >/dev/null 2>&1 && ! command -v gcc >/dev/null 2>&1; then
    printf '[WARN] No C linker found — installing build-essential.\n'
    if command -v apt-get >/dev/null 2>&1; then
      sudo apt-get update && sudo apt-get install -y --no-install-recommends build-essential
    else
      printf '[ERROR] No apt-get available - install a C toolchain manually.\n' >&2
      return 1
    fi
  fi
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

verify_default_toolchain
ensure_linker

printf '[INFO] Rust installed: %s\n' "$("${CARGO_HOME}/bin/rustc" --version)"

cat <<EOF

[INFO] Wire this up permanently in two places:

  1. ~/.config/shell/environment.sh   (pure vars, no PATH dependency)

       export CARGO_HOME="\${XDG_DATA_HOME}/cargo"
       export RUSTUP_HOME="\${XDG_DATA_HOME}/rustup"

  2. your shell's login-profile file  (PATH-dependent - order doesn't
     matter relative to brew/fnm/etc since cargo/bin has no conflicts,
     but keep it after the XDG vars are set)

       export PATH="\${CARGO_HOME}/bin:\${PATH}"

Then open a NEW terminal window and verify with: cargo --version

EOF

# vim: ft=sh ts=2 sts=2 sw=2 sr et
