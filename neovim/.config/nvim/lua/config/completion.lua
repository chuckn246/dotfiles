-- ------------------------------------------------------------
-- Completion
-- ------------------------------------------------------------

local keymap = vim.keymap.set

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

-- vim: ft=lua ts=2 sts=2 sw=2 et
