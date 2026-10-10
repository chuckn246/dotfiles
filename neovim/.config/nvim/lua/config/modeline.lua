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

  -- Wrap modeline in the current filetype's comment syntax
  local commentstring = vim.bo.commentstring

  if commentstring:find("%%s") then
    modeline = commentstring:gsub("%%s", function()
      return modeline
    end)
  end

  -- Append blank line and modeline at EOF
  vim.api.nvim_buf_set_lines(0, -1, -1, false, {
    "",
    modeline,
  })
end

vim.keymap.set("n", "<leader>ml", append_modeline, {
  silent = true,
  desc = "Append modeline",
})

-- vim: ft=lua ts=2 sts=2 sw=2 et
