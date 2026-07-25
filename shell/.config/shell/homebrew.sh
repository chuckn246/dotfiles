brew_binary=''
[ -x "/opt/homebrew/bin/brew" ] && brew_binary="/opt/homebrew/bin/brew"

if [ -n "${brew_binary}" ]; then
  eval "$("${brew_binary}" shellenv)"
  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_REQUIRE_TAP_TRUST=1
fi

# vim: ft=sh ts=2 sts=2 sw=2 sr et
