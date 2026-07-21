## Less Dotfiles

This repo sets up dotfiles for [lesskey](https://manpages.debian.org/stable/less/lesskey.1.en.html) and [lesspipe](https://github.com/wofr06/lesspipe)

There is also a script that will install or update **lesspipe** from it's git repository.

When running `stow`, it will be symlinked to a directory in $PATH.

### Installing
- Create a hidden dotfiles directory:

        mkdir -p "${HOME}/.dotfiles"


- Change directories:

        cd "${HOME}/.dotfiles"


- Clone this repo

        git clone git@github.com:cn246-dotfiles/less.git


- Stow the dotfiles:

        stow --verbose --no-folding less

- Open new terminal tab or window to update $PATH:

        <cmd> + t


- Install or update **lesspipe**:

        update-lesspipe


### Links
- https://manpages.debian.org/stable/less/lesskey.1.en.html
- https://github.com/wofr06/lesspipe
- https://www.gnu.org/software/stow/manual/stow.html
