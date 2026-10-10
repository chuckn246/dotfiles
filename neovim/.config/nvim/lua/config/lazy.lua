-- ------------------------------------------------------------
-- Plugin Manager (lazy.nvim)
-- ------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"


-- ------------------------------------------------------------
-- Bootstrap
-- ------------------------------------------------------------

-- Install lazy.nvim automatically if it is missing
if not vim.uv.fs_stat(lazypath) then
  local repository = "https://github.com/folke/lazy.nvim.git"

  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    repository,
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    error("Failed to install lazy.nvim:\n" .. output)
  end
end

-- Add lazy.nvim to Neovim's runtime path
vim.opt.rtp:prepend(lazypath)


-- ------------------------------------------------------------
-- Configuration
-- ------------------------------------------------------------

require("lazy").setup({
  -- Load plugin specifications from lua/plugins/
  spec = {
    { import = "plugins" },
  },

  -- Colorscheme used during initial plugin installation
  install = {
    colorscheme = { "habamax" },
  },

  -- Check for plugin updates without installing them
  checker = {
    enabled = true,
    notify = true,
  },

  -- Detect configuration changes without notifications
  change_detection = {
    enabled = true,
    notify = false,
  },

  -- Use ASCII icons instead of Nerd Font glyphs
  ui = {
    icons = {
      cmd = ":",
      config = "*",
      debug = "D",
      event = "@",
      favorite = "*",
      ft = "FT",
      init = "I",
      import = "->",
      keys = "K",
      lazy = "L",
      loaded = "+",
      not_loaded = "-",
      plugin = "P",
      runtime = "R",
      require = "r",
      source = "S",
      start = ">",
      task = "+",
      list = { "+", ">", "*", "-" },
    },
  },
})

-- vim: ft=lua ts=2 sts=2 sw=2 et
