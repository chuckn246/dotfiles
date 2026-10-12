-- ------------------------------------------------------------
-- Global Settings
-- ------------------------------------------------------------

-- Configure leader keys before loading plugins or mappings
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable netrw in favor of nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable unused external language providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0


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
require("config.lsp")
require("config.lint")
require("config.treesitter")


-- ------------------------------------------------------------
-- Keymaps and Utilities
-- ------------------------------------------------------------

-- Load keyboard mappings and editor utilities
require("config.terminal")
require("config.whitespace")
require("config.conflicts")
require("config.modeline")
require("config.keymaps")

-- vim: ft=lua ts=2 sts=2 sw=2 et
