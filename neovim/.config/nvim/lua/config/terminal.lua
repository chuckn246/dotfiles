-- ------------------------------------------------------------
-- Terminal Management
-- ------------------------------------------------------------

-- Open a terminal in the requested window layout
local function open_terminal(layout)
  vim.cmd(layout)
  vim.cmd("terminal")

  -- Mark terminals created by these mappings for automatic cleanup
  vim.b.managed_terminal = true

  -- Enter terminal mode immediately
  vim.cmd("startinsert")
end


-- ------------------------------------------------------------
-- Autocommands
-- ------------------------------------------------------------

local group = vim.api.nvim_create_augroup("TerminalConfig", {
  clear = true,
})

-- Close managed terminal buffers after successful shell exit
vim.api.nvim_create_autocmd("TermClose", {
  group = group,
  callback = function(args)
    local bufnr = args.buf

    -- Neovim may have already deleted the terminal buffer
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end

    -- Only manage terminals opened by our keybindings
    if not vim.b[bufnr].managed_terminal then
      return
    end

    -- Preserve terminal output when the command fails
    if vim.v.event.status ~= 0 then
      return
    end

    -- Schedule deletion outside the terminal event
    vim.schedule(function()
      -- The buffer may have been deleted before cleanup runs
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_delete(bufnr, {
          force = true,
        })
      end
    end)
  end,
  desc = "Close managed terminals after successful exit",
})


-- ------------------------------------------------------------
-- Module
-- ------------------------------------------------------------

return {
  open = open_terminal,
}

-- vim: ft=lua ts=2 sts=2 sw=2 et
