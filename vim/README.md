## Vim Dotfiles

You've found my Vim dotfiles!

Vim dotfiles are a bunch of personal preferences, so what works for me may not
be the best setup for someone else.

There are a few other tweaks in the `~/.vimrc` that I've found around the web
and tweaked to my liking.

----

### Keybinds

|Plugin  | Key Bind     | Function      |
|--------| -------------|---------------|
|Vim     | `space`      | Leader        |
|Vim     | `F5`         | Toggle Spellcheck |
|Vim     | `F6`         | (in **editor buffer**) Open terminal new tab |
|Vim     | `F6`         | (in **terminal insert mode**) Enter terminal normal mode |
|Vim     | `F11`        | Toggle paste mode |
|Vim     | `<leader>ml` | Append vim modeline |
|Vim     | `<leader>pv` | Toggle file browser using `Lexplore` |
|Vim     | `<leader>sv` | Reload .vimrc |
|Vim     | `<leader>t`  | Open terminal at bottom of screen |
|Vim     | `<leader>T`  | Open terminal in new tab |
|Vim     | `<leader>p`  | Paste from system clipboard |
|Vim     | `<leader>y`  | Yank to system clipboard |
|Vim     | `<leader>w`  | Trim whitespace |
|Vim     | `<Ctrl>l`    | Toggle search highlight |
|ALE     | `<leader>af` | Run ALEFix |
|ALE     | `<leader>at` | Toggle ALE |
|ALE     | `<Ctrl>j`    | Next ALE error |
|ALE     | `<Ctrl>k`    | Previous ALE error |

----

### Plugins
I try not to install a bunch of plugins. It makes for an easy transition when I
log into a server without my dotfiles.


#### dense-analysis - ale
I'm a big fan of the linting (and fixing) capabilities that ALE offers.


#### hashivim - vim-terraform
Mainly used for terraform syntax hilighting.


#### kshenoy - vim-signature
Helps view and manage Vim marks.


#### tpope - vim-commentary
This makes commenting and uncommenting code extremely convenient.


#### tpope - vim-fugitive
Slowly warming up to this one..

I've had it installed for a while but haven't explored what it offers.

I can definitely see how it will be handy and am going to attempt to integrate
it into my workflow.


#### tpope - vim-repeat
I use this all the time to repeat surrounds.


#### tpope - vim-surround
I use this all the time too. Easy wrapping text with quotes and brackets.


#### vim/plugged/vim-redact-pass
Found this one when reading up on the `pass` password manager.
https://dev.sanctum.geek.nz/cgit/vim-redact-pass.git/about/
