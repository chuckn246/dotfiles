-- ------------------------------------------------------------
-- Markdown
-- ------------------------------------------------------------

local opt = vim.opt_local


-- ------------------------------------------------------------
-- Editing
-- ------------------------------------------------------------

-- Preserve literal tabs when using the Tab key
opt.expandtab = false

-- Disable file-embedded modelines
opt.modeline = false


-- ------------------------------------------------------------
-- Spelling
-- ------------------------------------------------------------

-- Enable American English spell checking
opt.spell = true
opt.spelllang = "en_us"

-- vim: ft=lua ts=2 sts=2 sw=2 et
