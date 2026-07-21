#!/bin/sh

archi=$(uname -s)
case "$archi" in
  Darwin)
    open -a Firefox "$1"
    ;;
  Linux)
    firefox "$1"
    ;;
  *)
    printf '%s\n' "Unknown OS"
    ;;
esac

# vim: ts=2 sts=2 sw=2 sr et
