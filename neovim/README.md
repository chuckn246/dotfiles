# Neovim Configuration

Personal Neovim configuration written in Lua and managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

Designed to provide a lightweight, terminal-focused editing environment while preserving familiar Vim functionality and keybindings.

## Requirements

- Neovim 0.12+
- Git
- Additional dependencies as required by individual plugins

## Installation

Clone the repository and symlink the configuration directory to `~/.config/nvim`.

Start Neovim:

```sh
nvim
```

lazy.nvim will bootstrap automatically and install the configured plugins. Additional external dependencies must be installed separately.

## Structure

| Path | Description |
| --- | --- |
| `init.lua` | Main configuration entry point |
| `lua/config/` | Editor configuration and settings |
| `lua/plugins/` | Plugin definitions |
| `after/ftplugin/` | Filetype-specific configuration |
| `lazy-lock.json` | Plugin version lockfile |

## Notes

- Configuration is independent of traditional Vim.
- Plugin versions are tracked through lazy.nvim.
