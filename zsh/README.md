# ZSH

Here be my zsh dotfiles. I started my zsh journey using [oh-my-zsh](https://ohmyz.sh/),
but realized that I don't need all the extras that come with it.

So I stripped the parts that I liked and modified all the things to meet my current needs.

----

## Details
- Sets `ZDOTDIR` to `~/.config/zsh` and moves some files to subdirectories in there.
- Uses the [vi-mode plugin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/vi-mode) from oh-my-zsh
- Uses the [gpg-agent plugin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/gpg-agent) from oh-my-zsh
- Created a prompt based off of `/usr/share/zsh/5.8.1/functions/prompt_clint_setup`
- Uses zsh's `vcs_info` features to create git prompt:
  - `<branch>` - Branch name
  - `*` - Unstaged file
  - `+` - Staged file
  - `%` - Untracked files
  - `+x` - Where x is the number of commits ahead

----

## Installation
I keep all my dotfiles in `~/.dotfiles/<repo>` and use [stow](https://www.gnu.org/software/stow/) to place them.

- Create directory:
```bash
mkdir ~/.dotfiles
```
- Change directory:
```bash
cd ~/.dotfiles
```
- Clone repo:
```bash
git clone git@github.com:cn246-dotfiles/dotfiles-zsh.git zsh
```
- Delete existing dotfiles (might want to back them up instead):
```bash
files=( .zcompdump* .zprofile .zshenv .zsh_history .zshrc )

for file in "$HOME/${files[@]}"; do rm -f "$file" done
```
- Stow:
```bash
stow --no-folding zsh
```

----
