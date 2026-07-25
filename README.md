# Dotfiles
A reproducible Unix workstation configuration built around GNU Stow, Homebrew, and modern command-line tooling.

This repository contains my personal shell configuration, editor settings, terminal configuration, and bootstrap scripts for provisioning a new development machine. Although my primary development platform is macOS, the configurations are written with portability in mind and are intended to work across modern Unix-like systems whenever practical.


## Features
* GNU Stow managed dotfiles
* Automated workstation bootstrap
* Bash and Zsh support
* XDG-friendly configuration where practical
* Modular repository structure
* Minimal external dependencies
* Portable shell configuration using feature detection instead of platform detection


## Bootstrap
The repository includes a bootstrap process that provisions a new workstation with a consistent development environment.

The bootstrap currently performs the following tasks:

1. Creates the required directory structure under `$HOME`
2. Installs and configures Homebrew on Mac
3. Installs and configures developer toolchains
6. Symlinks the selected configuration packages using GNU Stow

The bootstrap process is intentionally modular so that individual installation steps can be maintained independently.

Run the bootstrap with:
```sh
./bootstrap/bootstrap.sh
```

## Installation
Clone the repository:
```sh
cd ~
git clone https://github.com/chuckn246/dotfiles.git .dotfiles
cd .dotfiles
```

Install individual packages with GNU Stow:
```sh
stow git
stow zsh
stow vim
stow tmux
```

Or bootstrap an entire workstation:
```sh
./bootstrap/bootstrap.sh
```


## Platform Support
| Platform                  | Status                       |
| ------------------------- | ---------------------------- |
| macOS (Homebrew)          | Primary development platform |
| Debian                    | Expected to work             |
| Ubuntu                    | Expected to work             |
| Other Linux distributions | Best effort                  |
