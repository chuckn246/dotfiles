-- ------------------------------------------------------------
-- Keymaps
-- ------------------------------------------------------------

local keymap = vim.keymap.set


-- ------------------------------------------------------------
-- Commands
-- ------------------------------------------------------------

-- Correct common command-line typos
vim.api.nvim_create_user_command("W", "write", {})
vim.api.nvim_create_user_command("Q", "quit", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("WQ", "wq", {})


-- ------------------------------------------------------------
-- Windows and Splits
-- ------------------------------------------------------------

-- Navigate between windows using leader + h/j/k/l
keymap("n", "<leader>h", "<C-w>h", { desc = "Window left" })
keymap("n", "<leader>j", "<C-w>j", { desc = "Window down" })
keymap("n", "<leader>k", "<C-w>k", { desc = "Window up" })
keymap("n", "<leader>l", "<C-w>l", { desc = "Window right" })


-- ------------------------------------------------------------
-- Buffers
-- ------------------------------------------------------------

-- List available buffers and prompt for selection
keymap("n", "gb", ":ls<CR>:buffer ", {
  desc = "List and select buffer",
})

-- Select a buffer using filename expansion
keymap("n", "<leader>b", ":buffer *", {
  desc = "Select buffer by pattern",
})


-- ------------------------------------------------------------
-- Clipboard
-- ------------------------------------------------------------

-- Yank text to the system clipboard
keymap({ "n", "x" }, "<leader>y", '"+y', {
  desc = "Yank to clipboard",
})


-- ------------------------------------------------------------
-- Completion
-- ------------------------------------------------------------

-- Manually request completion suggestions from attached language servers
keymap("i", "<C-Space>", "<C-x><C-o>", {
  desc = "Trigger LSP completion",
})

-- Select the next completion item
keymap("i", "<C-j>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
end, {
  expr = true,
  desc = "Next completion",
})

-- Select the previous completion item, or enter a digraph
keymap("i", "<C-k>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-k>"
end, {
  expr = true,
  desc = "Previous completion",
})


-- ------------------------------------------------------------
-- File Navigation
-- ------------------------------------------------------------

-- Toggle nvim-tree sidebar
keymap("n", "<leader>pv", "<cmd>NvimTreeToggle<CR>", {
  desc = "Toggle file explorer",
})


-- ------------------------------------------------------------
-- Formatting
-- ------------------------------------------------------------

-- Format the current buffer using its configured formatter
keymap("n", "<leader>af", function()
  require("conform").format({
    async = true,
    lsp_format = "never",
  })
end, {
  desc = "Format buffer",
})


-- ------------------------------------------------------------
-- FZF
-- ------------------------------------------------------------

-- Search files by filename
keymap("n", "<leader>ff", "<cmd>Files<CR>", {
  desc = "Find files",
})

-- Search file contents using ripgrep
keymap("n", "<leader>fg", "<cmd>Rg<CR>", {
  desc = "Search file contents",
})

-- Search open buffers
keymap("n", "<leader>fb", "<cmd>Buffers<CR>", {
  desc = "Find buffers",
})


-- ------------------------------------------------------------
-- Git (Fugitive)
-- ------------------------------------------------------------

-- Open Git status
keymap("n", "<leader>gs", "<cmd>Git<CR>", {
  desc = "Git status",
})

-- Show Git blame for the current file
keymap("n", "<leader>gb", "<cmd>Git blame<CR>", {
  desc = "Git blame",
})


-- ------------------------------------------------------------
-- Modeline
-- ------------------------------------------------------------

local modeline = require("config.modeline")

-- Insert a modeline for the current buffer
keymap("n", "<leader>ml", modeline.insert, {
  desc = "Insert modeline",
})


-- ------------------------------------------------------------
-- Searching
-- ------------------------------------------------------------

-- Clear search highlighting and redraw the screen
keymap("n", "<C-l>", "<cmd>nohlsearch<CR><C-l>", {
  desc = "Clear search highlighting",
})


-- ------------------------------------------------------------
-- Terminal
-- ------------------------------------------------------------

local terminal = require("config.terminal")

-- Open a terminal in a horizontal split
keymap("n", "<leader>t", function()
  terminal.open("split")
end, {
  desc = "Terminal horizontal split",
})

-- Open a terminal in a vertical split
keymap("n", "<leader>T", function()
  terminal.open("vsplit")
end, {
  desc = "Terminal vertical split",
})

-- Enter Terminal-Normal mode to navigate or copy terminal output
keymap("t", "<C-w>n", "<C-\\><C-n>", {
  desc = "Terminal-Normal mode",
})


-- ------------------------------------------------------------
-- Terminal Window Navigation
-- ------------------------------------------------------------

-- Preserve Vim-style window navigation while in Terminal mode
local directions = {
  h = "h",
  j = "j",
  k = "k",
  l = "l",
  w = "w",
  p = "p",
}

for key, motion in pairs(directions) do
  keymap("t", "<C-w>" .. key, "<C-\\><C-n><C-w>" .. motion, {
    desc = "Navigate terminal windows",
  })
end


-- ------------------------------------------------------------
-- Whitespace
-- ------------------------------------------------------------

local whitespace = require("config.whitespace")

-- Manually remove trailing whitespace
keymap("n", "<leader>w", whitespace.trim, {
  desc = "Trim trailing whitespace",
})


-- ------------------------------------------------------------
-- Diagnostics
-- ------------------------------------------------------------

-- Toggle diagnostic display for the current buffer
keymap("n", "<leader>at", function()
  local enabled = vim.diagnostic.is_enabled({ bufnr = 0 })

  vim.diagnostic.enable(not enabled, { bufnr = 0 })
end, {
  desc = "Toggle diagnostics",
})

-- Jump to the next diagnostic (error, warning, or hint)
keymap("n", "<C-j>", function()
  vim.diagnostic.jump({
    count = 1,
    float = true,
  })
end, {
  desc = "Next diagnostic",
})

-- Jump to the previous diagnostic
keymap("n", "<C-k>", function()
  vim.diagnostic.jump({
    count = -1,
    float = true,
  })
end, {
  desc = "Previous diagnostic",
})

-- Display diagnostics for the current buffer in the location list
keymap("n", "<leader>dl", function()
  vim.diagnostic.setloclist()
end, {
  desc = "List diagnostics",
})

-- vim: ft=lua ts=2 sts=2 sw=2 et
