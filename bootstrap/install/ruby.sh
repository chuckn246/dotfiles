#!/usr/bin/env bash

set -euo pipefail

: "${XDG_DATA_HOME:=${HOME}/.local/share}"
: "${XDG_STATE_HOME:=${HOME}/.local/state}"

export RBENV_ROOT="${XDG_DATA_HOME}/rbenv"

ruby_version="${RUBY_VERSION:-4.0}"

install_dependencies() {
  case "$(uname -s)" in
    Darwin)
      if ! command -v brew >/dev/null 2>&1; then
        printf '[ERROR] Homebrew is required on macOS.\n' >&2
        return 1
      fi

      if ! xcode-select -p >/dev/null 2>&1; then
        printf '[ERROR] Xcode Command Line Tools are required: xcode-select --install\n' >&2
        return 1
      fi

      printf '[INFO] Installing rbenv and Ruby build dependencies via Homebrew\n'
      brew install rbenv openssl@3 libyaml gmp autoconf readline

      rbenv_bin="$(brew --prefix)/bin/rbenv"
      ruby_build_bin="$(brew --prefix)/bin/ruby-build"
      ;;

    Linux)
      if ! command -v apt-get >/dev/null 2>&1; then
        printf '[ERROR] This script supports Debian/Ubuntu on Linux.\n' >&2
        return 1
      fi

      local -a packages=(
        git curl ca-certificates build-essential autoconf bison
        libssl-dev libyaml-dev zlib1g-dev libffi-dev libgmp-dev
      )
      local -a missing=()
      local package

      for package in "${packages[@]}"; do
        if ! dpkg-query -W -f='${Status}' "${package}" 2>/dev/null | grep -qx 'install ok installed'; then
          missing+=("${package}")
        fi
      done

      if ((${#missing[@]} > 0)); then
        printf '[INFO] Installing Ruby build dependencies via APT\n'
        sudo apt-get update
        sudo apt-get install -y --no-install-recommends "${missing[@]}"
      fi

      if [ ! -x "${RBENV_ROOT}/bin/rbenv" ]; then
        if [ -e "${RBENV_ROOT}" ]; then
          printf '[ERROR] Existing rbenv directory is incomplete: %s\n' "${RBENV_ROOT}" >&2
          return 1
        fi

        printf '[INFO] Installing rbenv\n'
        git clone --depth 1 https://github.com/rbenv/rbenv.git "${RBENV_ROOT}"
      fi

      if [ ! -x "${RBENV_ROOT}/plugins/ruby-build/bin/ruby-build" ]; then
        printf '[INFO] Installing ruby-build\n'
        mkdir -p "${RBENV_ROOT}/plugins"
        git clone --depth 1 https://github.com/rbenv/ruby-build.git "${RBENV_ROOT}/plugins/ruby-build"
      fi

      rbenv_bin="${RBENV_ROOT}/bin/rbenv"
      ruby_build_bin="${RBENV_ROOT}/plugins/ruby-build/bin/ruby-build"
      ;;

    *)
      printf '[ERROR] Unsupported operating system.\n' >&2
      return 1
      ;;
  esac
}

install_ruby() {
  local resolved_version

  if ! resolved_version="$("${ruby_build_bin}" --resolve "${ruby_version}")"; then
    printf '[ERROR] Unable to resolve Ruby version: %s\n' "${ruby_version}" >&2
    return 1
  fi

  printf '[INFO] Installing Ruby %s (if missing)\n' "${resolved_version}"

  "${rbenv_bin}" install -s "${resolved_version}"
  "${rbenv_bin}" global "${resolved_version}"
  "${rbenv_bin}" rehash

  local ruby_bin="${RBENV_ROOT}/versions/${resolved_version}/bin/ruby"

  if [ ! -x "${ruby_bin}" ]; then
    printf '[ERROR] Ruby binary not found: %s\n' "${ruby_bin}" >&2
    return 1
  fi

  printf '[INFO] Ruby installed: %s\n' "$("${ruby_bin}" --version)"
}

# Allow ruby-build to find Rust installed with our XDG-aware rustup script.
if [ -x "${XDG_DATA_HOME}/cargo/bin/rustc" ]; then
  export PATH="${XDG_DATA_HOME}/cargo/bin:${PATH}"
fi

install_dependencies
install_ruby

mkdir -p "${XDG_STATE_HOME}/irb"

cat <<'EOF'

[INFO] Wire this up permanently in two places:

  1. ~/.config/shell/environment.sh (pure vars)

       export RBENV_ROOT="${XDG_DATA_HOME}/rbenv"

  2. Your shell's login-profile file (after XDG vars are defined)

       export PATH="${RBENV_ROOT}/bin:${RBENV_ROOT}/shims:${PATH}"

Then open a NEW terminal window and verify with:

       ruby --version
       gem --version
       rbenv version

EOF

# vim: ft=sh ts=2 sts=2 sw=2 sr et
