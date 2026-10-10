-- ------------------------------------------------------------
-- Git Commit Messages
-- ------------------------------------------------------------

local opt = vim.opt_local


-- ------------------------------------------------------------
-- Formatting
-- ------------------------------------------------------------

-- Wrap commit message bodies at 72 characters
opt.textwidth = 72

-- Highlight the text width and conventional subject limit
opt.colorcolumn = { "+1", "51" }


-- ------------------------------------------------------------
-- Spelling
-- ------------------------------------------------------------

-- Enable American English spell checking
opt.spell = true
opt.spelllang = "en_us"

-- vim: ft=lua ts=2 sts=2 sw=2 et
