# SSH Key Management

if ssh-add -l >/dev/null 2>&1; then
  # Agent exists and is responding - do nothing
  :
elif [[ -n "${SSH_CONNECTION}" ]]; then
  # In SSH session - Don't try to start local agent or load keys
  :
else
    case $(uname -s) in
      "Darwin")
        # macOS: Load keys from Keychain
        ssh-add --apple-load-keychain 2>/dev/null
        ;;
      "Linux")
        #  Linux: Find and add all private keys in ~/.ssh/
        if grep -qslR "PRIVATE" "${HOME}/.ssh/" 2>/dev/nul; then
          ssh-add -l >/dev/null 2>&1 || ( grep -slR "PRIVATE" "${HOME}/.ssh/" | xargs ssh-add )
        fi
        ;;
    esac
fi

# vim: ft=zsh ts=8 sts=2 sw=2 sr et
