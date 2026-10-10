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

-- Paste text from the system clipboard
keymap({ "n", "x" }, "<leader>p", '"+p', {
  desc = "Paste from clipboard",
})


-- ------------------------------------------------------------
-- File Navigation
-- ------------------------------------------------------------

-- Toggle nvim-tree sidebar
keymap("n", "<leader>pv", "<cmd>NvimTreeToggle<CR>", {
  desc = "Toggle file explorer",
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
-- Searching
-- ------------------------------------------------------------

-- Clear search highlighting and redraw the screen
keymap("n", "<C-l>", "<cmd>nohlsearch<CR><C-l>", {
  desc = "Clear search highlighting",
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
