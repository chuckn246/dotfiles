# Bootstrap
Scripts and configuration for provisioning a workstation from this dotfiles repository.

The bootstrap process is designed to be idempotent: running it multiple times should converge the system toward the desired state without requiring manual cleanup.


## Usage
From the repository root:
```bash
./bootstrap/bootstrap.sh
```

The bootstrap process will:
- Create standard user directories
- Install and configure Homebrew on Mac
- Install developer toolchains and utilities
- Configure dotfiles using GNU Stow


## Requirements
The bootstrap assumes:
- MacOS
- `git`
- `curl`
- Internet access
- Administrative privileges when installing system software

Some installation steps may require additional dependencies depending on the current system state.


## Configuration
The following files control bootstrap behavior:
**`config/directories.conf`**
Defines directories that should exist in the user's home directory. Entries are one directory per line, blank lines and comments are ignored.

Example:
```
Projects
Projects/ansible
Projects/terraform
```

**`config/stow.conf`**
Defines Stow packages to apply. Entries are one package per line, blank lines and comments are ignored.

Example:
```
git
tmux
vim
zsh
```

**`brew/Brewfile`**
Defines Homebrew packages, taps, casks, and other Homebrew-managed resources.


## Notes
Before running the bootstrap on an existing system:
- Review the Stow packages that will be enabled.
- Ensure existing configuration files will not conflict with managed files.
- Review installer scripts before running them on an unfamiliar machine.
