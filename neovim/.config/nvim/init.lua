-- ------------------------------------------------------------
-- Global Settings
-- ------------------------------------------------------------

-- Configure leader keys before loading plugins or mappings
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


-- ------------------------------------------------------------
-- Built-in File Explorer
-- ------------------------------------------------------------

-- Disable netrw in favor of nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


-- ------------------------------------------------------------
-- Filetype Detection
-- ------------------------------------------------------------

-- Register custom filename and content-based filetype rules
require("config.filetypes")


-- ------------------------------------------------------------
-- General Options
-- ------------------------------------------------------------

-- Load editor options and preferences
require("config.options")


-- ------------------------------------------------------------
-- Plugin Manager
-- ------------------------------------------------------------

-- Initialize lazy.nvim and load plugin specifications
require("config.lazy")


-- ------------------------------------------------------------
-- Language Support
-- ------------------------------------------------------------

-- Configure language servers, external linters, and syntax highlighting
require("config.completion")
require("config.lsp")
require("config.lint")
require("config.treesitter")


-- ------------------------------------------------------------
-- Keymaps and Utilities
-- ------------------------------------------------------------

-- Load keyboard mappings and editor utilities
require("config.keymaps")
require("config.terminal")
require("config.whitespace")
require("config.conflicts")
require("config.modeline")

-- vim: ft=lua ts=2 sts=2 sw=2 et
