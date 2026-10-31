-- -----------------------------------------------------------
-- Modeline
-- https://vim.fandom.com/wiki/Modeline_magic#Adding_a_modeline
-- ------------------------------------------------------------

local function append_modeline()
  local modeline = string.format(
    "vim: ft=%s ts=%d sts=%d sw=%d %set",
    vim.bo.filetype,
    vim.bo.tabstop,
    vim.bo.softtabstop,
    vim.bo.shiftwidth,
    vim.bo.expandtab and "" or "no"
  )

  -- Normalize spacing around the comment string
  local before, after = vim.bo.commentstring:match("^(.-)%%s(.-)$")

  if before then
    before = before:gsub("%s+$", "")
    after = after:gsub("^%s+", "")

    modeline =
      (before ~= "" and before .. " " or "")
      .. modeline
      .. (after ~= "" and " " .. after or "")
  end

  -- Avoid adding an extra blank line
  local last = vim.api.nvim_buf_line_count(0)
  local tail = vim.api.nvim_buf_get_lines(0, last - 1, last, false)[1]

  local new_lines = tail == ""
      and { modeline }
      or { "", modeline }

  vim.api.nvim_buf_set_lines(0, -1, -1, false, new_lines)
end

-- ------------------------------------------------------------
-- Module
-- ------------------------------------------------------------

return {
  insert = append_modeline,
}

-- vim: ft=lua ts=2 sts=2 sw=2 et
