#!/usr/bin/env bash
# install-perl-xdg.sh - install perl + cpanm, wire local::lib to XDG dirs

set -euo pipefail

: "${XDG_DATA_HOME:=${HOME}/.local/share}"
: "${XDG_CACHE_HOME:=${HOME}/.cache}"

PERL5_BASE="${XDG_DATA_HOME}/perl5"
CPANM_HOME="${XDG_CACHE_HOME}/cpanm"

# Install perl + cpanm
if command -v brew >/dev/null 2>&1; then
  brew list perl >/dev/null 2>&1 || brew install perl
  brew list cpanminus >/dev/null 2>&1 || brew install cpanminus
elif command -v apt >/dev/null 2>&1; then
  command -v perl >/dev/null 2>&1 || { sudo apt update && sudo apt install -y perl; }
  command -v cpanm >/dev/null 2>&1 || sudo apt install -y cpanminus
else
  printf '%s\n' "[ERROR] No supported package manager found (expected brew or apt)." >&2
  exit 1
fi

mkdir -p "${PERL5_BASE}" "${CPANM_HOME}"

# Only install local::lib if it isn't already available
# Homebrew's perl bundles local::lib as a build dep, so cpanm would just
# report "up to date" and do nothing - harmless, but noisy and misleading.
# Debian/apt perl does NOT bundle it.
# `require` (not `-M`) avoids triggering import()
# side effects during the check itself.
if ! perl -e 'require local::lib' >/dev/null 2>&1; then
  printf '%s\n' "[INFO] local::lib not found — installing via cpanm..."
  PERL_CPANM_HOME="${CPANM_HOME}" \
    cpanm --local-lib="${PERL5_BASE}" local::lib
else
  printf '%s\n' "[INFO] local::lib already available (bundled with this perl)."
fi

# Bootstrap the XDG directory tree
# This is the step that actually creates lib/perl5, bin, man under
# PERL5_BASE. Must always pass =PATH explicitly - a bare -Mlocal::lib
# defaults to ~/perl5 and silently creates it, which is not what we want.
perl -I"${PERL5_BASE}/lib/perl5" -Mlocal::lib="${PERL5_BASE}" >/dev/null

printf '%s\n' "[INFO] local::lib environment bootstrapped under ${PERL5_BASE}"
find "${PERL5_BASE}" -maxdepth 2

# Sanity-check which perl this script actually ran against.
# This exists because the profile snippet (below) depends on `perl` resolving
# to the SAME binary at shell-startup time as it did here. On macOS with
# Homebrew, that only holds if `brew shellenv` runs before the local::lib
# eval in your dotfiles — get that ordering wrong and you silently fall back
# to system Perl (/Library/Perl or /usr/bin/perl), which won't see anything
# installed under PERL5_BASE. This check can't fix bad dotfile ordering, but
# it flags the symptom immediately instead of three cpanm installs later.
RESOLVED_PERL="$(command -v perl)"
if command -v brew >/dev/null 2>&1; then
  EXPECTED_PREFIX="$(brew --prefix perl 2>/dev/null || true)"
  case "${RESOLVED_PERL}" in
    "${EXPECTED_PREFIX}"*)
      printf '%s\n' "[INFO] perl resolves to Homebrew's build: ${RESOLVED_PERL}"
      ;;
    *)
      printf '%s\n' "[WARN] perl resolves to '${RESOLVED_PERL}', NOT Homebrew's (${EXPECTED_PREFIX}/bin/perl)."
      printf '%s\n' "[WARN] This usually means 'brew shellenv' has not run yet in this shell/context."
      printf '%s\n' "[WARN] Verify PATH ordering before relying on the profile snippet below."
      ;;
  esac
else
  printf '%s\n' "[INFO] perl resolves to: ${RESOLVED_PERL}"
fi

cat <<'EOF'

[INFO] Wire this up permanently in two places:

  1. ~/.config/shell/environment.sh   (sourced by ~/.zshenv - always loads,
     no PATH dependency, safe for pure variable exports)

       export PERL_CPANM_HOME="${XDG_CACHE_HOME}/cpanm"

  2. your shell's login-profile file  (login shells only - PATH-dependent,
     must come AFTER the `brew shellenv` line already in this file, so
     `perl` resolves to Homebrew's build and not system Perl)

       eval "$(perl -I"${XDG_DATA_HOME}/perl5/lib/perl5" -Mlocal::lib="${XDG_DATA_HOME}/perl5")"

Then open a NEW terminal window (login shell) - don't just `source` an
existing one, since local::lib env vars can duplicate if re-eval'd.

EOF

# vim: ft=sh ts=2 sts=2 sw=2 sr et
