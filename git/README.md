## Git Dotfiles

Here's my fairly basic git dotfiles.
Nothing too fancy, but great for my current use cases.

- Sets Vim as editor and for diffing
- Ansible vault integration
- Sign commits using ssh key
- One and two line status options
- Lengthy gitignore file

----

### Installing
- Create a hidden dotfiles directory:
```bash
mkdir -p "${HOME}/.dotfiles"
```

- Change directories:
```bash
cd "${HOME}/.dotfiles"
```

- Clone this repo
```bash
git clone git@github.com:cn246-dotfiles/git.git
```

- Stow the dotfiles:
```bash
stow --verbose --no-folding git
```

----

### Links
- https://git-scm.com/docs/git-config
- https://www.gnu.org/software/stow/manual/stow.html
