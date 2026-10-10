-- ------------------------------------------------------------
-- Git Merge Conflicts
-- ------------------------------------------------------------

local group = vim.api.nvim_create_augroup("GitConflictHighlight", {
  clear = true,
})


-- ------------------------------------------------------------
-- Highlight Configuration
-- ------------------------------------------------------------

-- Highlight Git merge conflict markers in orange
local function set_conflict_highlight()
  vim.api.nvim_set_hl(0, "GitConflictMarker", {
    fg = "#ffaf00",
    ctermfg = 208,
    bold = true,
  })
end

-- Initialize the highlight group
set_conflict_highlight()


-- ------------------------------------------------------------
-- Conflict Detection
-- ------------------------------------------------------------

-- Match Git merge conflict marker lines
local pattern = [[^\(<\{7}\||\{7}\|=\{7}\|>\{7}\).*$]]

-- Remove Git conflict matches from the current window
local function clear_conflict_highlight()
  -- Match highlighting is window-local and can survive buffer changes
  for _, match in ipairs(vim.fn.getmatches()) do
    if match.group == "GitConflictMarker" then
      vim.fn.matchdelete(match.id)
    end
  end
end

-- Highlight conflict markers in the current window
local function highlight_conflicts()
  -- Remove existing matches before updating the current window
  clear_conflict_highlight()

  -- Skip special buffers, including terminals
  if vim.bo.buftype ~= "" then
    return
  end

  -- Apply highlighting only to the current window
  vim.fn.matchadd(
    "GitConflictMarker",
    pattern,
    10
  )
end


-- ------------------------------------------------------------
-- Autocommands
-- ------------------------------------------------------------

-- Refresh highlighting when changing buffers or windows
vim.api.nvim_create_autocmd({
  "BufEnter",
  "BufWinEnter",
  "WinEnter",
  "TermOpen",
  "TermEnter",
}, {
  group = group,
  callback = highlight_conflicts,
  desc = "Highlight Git merge conflict markers",
})

-- Restore highlighting after changing colorschemes
vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = function()
    set_conflict_highlight()

    -- Refresh highlighting in every open window
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      vim.api.nvim_win_call(win, highlight_conflicts)
    end
  end,
  desc = "Restore Git conflict highlighting",
})

-- vim: ft=lua ts=2 sts=2 sw=2 et
