alias cp='cp -i'

case "$(uname -s)" in
  Darwin)
    if command -v gls >/dev/null; then
      alias ls='gls -h --group-directories-first --color=auto'
    else
      alias ls='ls -h --color=auto'
    fi
    ;;
  Linux)
    alias ls='ls -h --group-directories-first --color=auto'
    ;;
  *)
    alias ls='ls -h --color=auto'
    ;;
esac

alias mkdir='mkdir -p'
alias mv='mv -i'
alias rm='rm -i'

# vim: ft=sh ts=2 sts=2 sw=2 sr et
