#!/usr/bin/env bash

set -euo pipefail

install_go() {
  local os_name
  local os_arch
  local go_arch
  local go_kind
  local go_version
  local go_data
  local go_file_name
  local go_file_path
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
      # .pkg via Installer.app - already known-working, sets up PATH via
      # /etc/paths.d automatically. Left as-is to avoid disturbing it.
      go_kind="installer"
      ;;
    "Linux")
      # No installer.app equivalent - Go publishes a plain .tar.gz for
      # Linux ("archive" kind), which we extract to /usr/local/go
      # ourselves, matching Go's own documented install convention.
      go_kind="archive"
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
    aarch64)
        # uname -m on most Linux arm64 boxes reports aarch64, not arm64
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

  go_version=$(curl --disable --silent "${base_go_url}/VERSION?m=text" | head -n1)
  go_data=$(curl --disable --silent "${base_go_download_url}/?mode=json" \
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
  trap 'rm -rf "'"${tmpdir}"'"' EXIT
  # Keep the JSON filename and the local tmp path as separate variables -
  # reusing go_file_name for both previously leaked the tmpdir path into
  # the download URL itself (.../dl//tmp/tmp.XXXX/go1.x...), which likely
  # 404'd silently since this only runs when Go isn't already installed.
  go_file_path="${tmpdir}/${go_file_name}"
  curl --disable \
    --silent \
    --show-error \
    --location \
    --output "${go_file_path}" \
    "${base_go_download_url}/${go_file_name}"

  printf '[INFO] Verifying checksum...\n'
  # shasum ships by default on macOS; Debian's standard tool is sha256sum
  # (coreutils) instead - branch rather than require one specific binary.
  if [[ "${os_name}" == "Darwin" ]]; then
    local_hash=$(shasum -a 256 "${go_file_path}" | cut -d' ' -f1)
  else
    local_hash=$(sha256sum "${go_file_path}" | cut -d' ' -f1)
  fi

  if [[ "${go_file_hash}" != "${local_hash}" ]]; then
    printf '[ERROR] SHA256 verification failed.\n' >&2
    printf '[ERROR] Expected: %s\n' "${go_file_hash}" >&2
    printf '[ERROR] Actual:   %s\n' "${local_hash}" >&2
    return 1
  fi

  printf '[INFO] Installing Go %s...\n' "${go_version}"
  if [[ "${os_name}" == "Darwin" ]]; then
    sudo installer \
      -pkg "${go_file_path}" \
      -target /
  else
    # Go's own documented convention: wipe any prior install to avoid a
    # mixed old/new stdlib, then extract fresh into /usr/local/go.
    [[ -d /usr/local/go ]] && sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "${go_file_path}"
    printf '[WARN] Add /usr/local/go/bin to PATH - not done automatically.\n'
  fi
}

if command -v go >/dev/null 2>&1; then
  printf '[INFO] Go already installed!\n'
  exit 0
fi

os_name="$(uname)"
required_cmds=(curl jq)
if [[ "${os_name}" == "Darwin" ]]; then
  required_cmds+=(shasum installer)
else
  required_cmds+=(sha256sum tar)
fi

for cmd in "${required_cmds[@]}"; do
  if ! command -v "${cmd}" >/dev/null; then
    printf '[ERROR] Missing dependency: %s\n' "${cmd}" >&2
    exit 1
  fi
done

if ! install_go; then
  printf '[ERROR] Trouble installing Go!\n' >&2
  exit 1
fi

case "$(basename "${SHELL:-}")" in
  zsh)  profile_file="~/.config/zsh/.zprofile" ;;
  bash) profile_file="~/.bash_profile (or ~/.profile if that doesn't exist)" ;;
  *)    profile_file="your shell's login-profile file" ;;
esac

# macOS's .pkg installer registers /usr/local/go/bin via /etc/paths.d/go
# automatically - nothing further needed there. Linux's tar extraction
# has no equivalent mechanism, so PATH needs a manual, deliberate addition.
if [[ "${os_name}" == "Darwin" ]]; then
  cat <<EOF

[INFO] Go installed via the macOS .pkg installer.
[INFO] /usr/local/go/bin is registered automatically via /etc/paths.d/go -
[INFO] no PATH changes needed. Open a NEW terminal window and verify with:
[INFO]   go version

EOF
else
  cat <<EOF

[INFO] Wire this up permanently in your shell's login-profile file (PATH-dependent):

    export PATH="/usr/local/go/bin:\${PATH}"

Then open a NEW terminal window and verify with: go version

EOF
fi

# vim: ft=sh ts=2 sts=2 sw=2 sr et
