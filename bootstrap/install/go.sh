#!/usr/bin/env bash

set -euo pipefail

readonly BASE_URL="https://go.dev"
readonly INSTALL_DIR="/usr/local/go"

fail() {
  printf '[ERROR] %s\n' "$*" >&2
  exit 1
}

# Read the version bundled with a specific Go executable, without external parsing tools.
# GOTOOLCHAIN=local prevents workspace-driven auto-selection of another toolchain.
get_go_version() {
  local output prefix command version rest
  output="$(GOTOOLCHAIN=local "$1" version)" || return 1
  read -r prefix command version rest <<< "${output}"
  [[ "${prefix}" == "go" && "${command}" == "version" && -n "${version}" ]] || return 1
  printf '%s\n' "${version}"
}

# Return success if $1 is a newer Go release than $2.
# Both inputs must be validated goX.Y[.Z] versions.
version_is_newer() {
  local a_major a_minor a_patch b_major b_minor b_patch

  IFS=. read -r a_major a_minor a_patch <<< "${1#go}"
  IFS=. read -r b_major b_minor b_patch <<< "${2#go}"
  a_patch="${a_patch:-0}"
  b_patch="${b_patch:-0}"

  if (( a_major != b_major )); then
    (( a_major > b_major ))
  elif (( a_minor != b_minor )); then
    (( a_minor > b_minor ))
  else
    (( a_patch > b_patch ))
  fi
}

tmpdir=""
cleanup() {
  if [[ -n "${tmpdir}" ]]; then
    rm -rf -- "${tmpdir}"
  fi
}
trap cleanup EXIT

case "$(uname -s)" in
  Darwin)
    go_os="darwin"
    go_kind="installer"
    hash_cmd=(shasum -a 256)
    required_cmds=(curl jq sudo installer shasum)
    ;;
  Linux)
    go_os="linux"
    go_kind="archive"
    hash_cmd=(sha256sum)
    required_cmds=(curl jq sudo tar sha256sum)
    ;;
  *) fail "Unsupported operating system: $(uname -s)" ;;
esac

case "$(uname -m)" in
  arm64|aarch64) go_arch="arm64" ;;
  x86_64)        go_arch="amd64" ;;
  *) fail "Unsupported architecture: $(uname -m)" ;;
esac

for cmd in "${required_cmds[@]}"; do
  command -v "${cmd}" >/dev/null 2>&1 || fail "Missing dependency: ${cmd}"
done

# Only manage the official installation. Do not overwrite Homebrew,
# mise, asdf, or another externally managed Go toolchain.
installed_version=""
if command -v go >/dev/null 2>&1; then
  go_path="$(command -v go)"
  [[ "${go_path}" == "${INSTALL_DIR}/bin/go" ]] || \
    fail "Go is provided by ${go_path}; update it using its own manager."
  installed_version="$(get_go_version "${go_path}")"
elif [[ -x "${INSTALL_DIR}/bin/go" ]]; then
  installed_version="$(get_go_version "${INSTALL_DIR}/bin/go")"
fi

# VERSION?m=text returns a version on the first line and metadata below it.
latest_version="$(curl --disable --fail --silent --show-error --location \
  "${BASE_URL}/VERSION?m=text" | sed -n '1p')"

version_pattern='^go[0-9]+\.[0-9]+(\.[0-9]+)?$'
[[ "${latest_version}" =~ ${version_pattern} ]] || \
  fail "Invalid version returned by go.dev: ${latest_version}"

printf '[INFO] Latest stable Go: %s\n' "${latest_version}"

if [[ -n "${installed_version}" ]]; then
  printf '[INFO] Installed Go:     %s\n' "${installed_version}"
  [[ "${installed_version}" =~ ${version_pattern} ]] || \
    fail "Unrecognized installed version: ${installed_version}"

  if [[ "${installed_version}" == "${latest_version}" ]]; then
    printf '[INFO] Go is already up to date.\n'
    exit 0
  fi

  if version_is_newer "${installed_version}" "${latest_version}"; then
    printf '[INFO] Installed Go is newer than the latest stable release; leaving it alone.\n'
    exit 0
  fi
fi

if [[ -n "${installed_version}" || -e "${INSTALL_DIR}" ]]; then
  printf '\n[WARN] An upgrade will replace the Go toolchain under %s.\n' "${INSTALL_DIR}"
  printf '[WARN] Back up any custom files you placed there before continuing.\n'
  [[ -t 0 ]] || fail 'An existing installation requires interactive confirmation.'
  read -r -p 'Continue with the Go upgrade? [y/N] ' answer || fail 'Could not read confirmation.'
  case "${answer}" in
    y|Y|yes|YES) ;;
    *) printf '[INFO] Upgrade cancelled.\n'; exit 0 ;;
  esac
fi

# Official metadata includes the exact filename and expected SHA256.
go_data="$(curl --disable --fail --silent --show-error --location \
  "${BASE_URL}/dl/?mode=json" |
  jq --raw-output \
    --arg os "${go_os}" \
    --arg arch "${go_arch}" \
    --arg kind "${go_kind}" \
    --arg version "${latest_version}" \
    'first(.[] | .files[] | select(
      .os == $os and .arch == $arch and
      .kind == $kind and .version == $version
    ) | "\(.filename)\t\(.sha256)")')"

[[ -n "${go_data}" ]] || fail 'Unable to locate official download metadata.'
IFS=$'\t' read -r go_filename expected_hash <<< "${go_data}"
[[ "${expected_hash}" =~ ^[[:xdigit:]]{64}$ ]] || fail 'Missing or invalid SHA256 checksum.'
[[ "${go_filename}" != */* ]] || fail 'Unsafe download filename.'

tmpdir="$(mktemp -d)"
file_path="${tmpdir}/${go_filename}"

printf '[INFO] Downloading %s...\n' "${go_filename}"
curl --disable --fail --silent --show-error --location \
  --output "${file_path}" \
  "${BASE_URL}/dl/${go_filename}"

actual_hash="$("${hash_cmd[@]}" "${file_path}" | awk '{print $1}')"
[[ "${actual_hash}" == "${expected_hash}" ]] || fail \
  "SHA256 mismatch (expected ${expected_hash}; got ${actual_hash})."

printf '[INFO] Checksum verified. Installing %s...\n' "${latest_version}"
if [[ "${go_os}" == "darwin" ]]; then
  sudo installer -pkg "${file_path}" -target /
else
  # Go explicitly requires removing the old distribution before extraction.
  if [[ -e "${INSTALL_DIR}" ]]; then
    sudo rm -rf -- "${INSTALL_DIR}"
  fi
  sudo tar -C /usr/local -xzf "${file_path}"
fi

verified_version="$(get_go_version "${INSTALL_DIR}/bin/go")"
[[ "${verified_version}" == "${latest_version}" ]] || \
  fail "Installed version is ${verified_version}, expected ${latest_version}."
printf '[INFO] Successfully installed %s.\n' "${verified_version}"

if [[ "${go_os}" == "linux" ]]; then
  cat <<'MESSAGE'
[INFO] Add this to your shell profile if necessary:
       export PATH="/usr/local/go/bin:${PATH}"
MESSAGE
else
  printf '[INFO] macOS registers /usr/local/go/bin through /etc/paths.d/go.\n'
fi
printf '[INFO] Open a new terminal and run: go version\n'

# vim: ft=sh ts=2 sts=2 sw=2 sr et
