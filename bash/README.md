# Bash Configuration

Bash configuration files for interactive shells and login environments.

This configuration is designed to work across macOS and Linux systems while sharing common environment settings and shell utilities with other shells.

Useful for having a familiar environment on systems without zsh.

## Layout
```
.
├── .bash_profile
├── .bashrc
├── .config/
│   └── bash/
│       └── prompt.sh
└── .profile
```

----

## Design Goals

- Maintain compatibility between macOS and Linux environments.
- Keep Bash-specific behavior separate from shared shell configuration.
- Avoid duplicating environment variables and utility functions.
- Keep startup files small and easy to debug.
- Prefer portable Bash features where possible.

----

## Shell Integration

Shared shell configuration is stored separately:
```
~/.config/shell/
├── aliases.sh
├── environment.sh
├── functions.sh
└── homebrew.sh
```

Bash loads these files during startup, while shell-specific behavior remains in `.bashrc`.

----

## Supported Environments

Primarily tested on:

- macOS with Homebrew Bash
- Debian-based Linux systems (todo)

The configuration should also work on other Unix-like systems with Bash installed.
