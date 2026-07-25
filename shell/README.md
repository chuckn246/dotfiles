# Shell Configuration

Shared shell configuration intended to be used by multiple shells and operating systems.

This directory contains shell-independent environment settings and reusable shell utilities. Shell-specific configuration (such as prompts, completion systems, and interactive behavior) should remain in the respective Bash or Zsh configuration directories.

----

## Design Goals
- Keep shared configuration portable between Bash and Zsh.  - Avoid duplicating environment configuration.
- Separate generated state/cache files from tracked configuration.
- Keep shell startup predictable and easy to debug.
- Prefer functions over aliases when behavior is more complex.

----

## Supported Environments

The configuration is primarily tested on:

- macOS with Homebrew
- Debian-based Linux systems (todo)

Additional Unix-like environments should work where required tools are available.
