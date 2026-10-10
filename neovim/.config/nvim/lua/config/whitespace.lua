-- ------------------------------------------------------------
-- Whitespace
-- ------------------------------------------------------------

local group = vim.api.nvim_create_augroup("TrailingWhitespace", {
  clear = true,
})


-- ------------------------------------------------------------
-- Highlight Configuration
-- ------------------------------------------------------------

-- Define the highlight group used for trailing whitespace
local function set_whitespace_highlight()
  vim.api.nvim_set_hl(0, "ExtraWhitespace", {
    fg = "#000000",
    bg = "#800000",
  })
end

-- Initialize the highlight group
set_whitespace_highlight()


-- ------------------------------------------------------------
-- Trailing Whitespace Detection
-- ------------------------------------------------------------

-- Remove trailing whitespace matches from the current window
local function clear_whitespace_highlight()
  -- Match highlighting is window-local and can survive buffer changes
  for _, match in ipairs(vim.fn.getmatches()) do
    if match.group == "ExtraWhitespace" then
      vim.fn.matchdelete(match.id)
    end
  end
end

-- Highlight trailing whitespace in the current window
local function highlight_trailing_whitespace()
  -- Remove existing matches before updating the current window
  clear_whitespace_highlight()

  -- Skip special buffers, including terminals, and Git commit messages
  if vim.bo.buftype ~= "" or vim.bo.filetype == "gitcommit" then
    return
  end

  -- Avoid highlighting whitespace beneath the cursor in Insert mode
  local pattern = [[\s\+$]]

  if vim.fn.mode() == "i" then
    pattern = [[\%#\@<!\s\+$]]
  end

  -- Apply highlighting only to the current window
  vim.fn.matchadd("ExtraWhitespace", pattern)
end


-- ------------------------------------------------------------
-- Autocommands
-- ------------------------------------------------------------

-- Refresh highlighting when changing buffers, windows, or editing modes
vim.api.nvim_create_autocmd({
  "BufEnter",
  "BufWinEnter",
  "WinEnter",
  "FileType",
  "InsertEnter",
  "InsertLeave",
  "TermOpen",
  "TermEnter",
}, {
  group = group,
  callback = highlight_trailing_whitespace,
  desc = "Update trailing whitespace highlighting",
})

-- Restore the highlight group after changing colorschemes
vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = function()
    set_whitespace_highlight()

    -- Refresh highlighting in every open window
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      vim.api.nvim_win_call(win, highlight_trailing_whitespace)
    end
  end,
  desc = "Restore trailing whitespace highlighting",
})


-- ------------------------------------------------------------
-- Whitespace Cleanup
-- ------------------------------------------------------------

-- Remove trailing whitespace without changing the cursor position
local function trim_whitespace()
  -- Do not attempt to modify terminal or other special buffers
  if vim.bo.buftype ~= "" then
    return
  end

  local view = vim.fn.winsaveview()

  -- Preserve search history and suppress errors when no matches exist
  local ok, err = pcall(function()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
  end)

  -- Restore the original cursor position and viewport
  vim.fn.winrestview(view)

  if not ok then
    vim.notify(tostring(err), vim.log.levels.ERROR)
  end
end


-- ------------------------------------------------------------
-- Keymaps
-- ------------------------------------------------------------

-- Manually remove trailing whitespace with leader + w
vim.keymap.set("n", "<leader>w", trim_whitespace, {
  desc = "Trim trailing whitespace",
})

-- vim: ft=lua ts=2 sts=2 sw=2 et
