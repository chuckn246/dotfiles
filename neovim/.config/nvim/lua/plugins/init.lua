-- ------------------------------------------------------------
-- Plugins
-- ------------------------------------------------------------

return {
  -- ------------------------------------------------------------
  -- Colorscheme
  -- ------------------------------------------------------------

  -- Everforest: https://github.com/sainnhe/everforest
  -- Configure Everforest with a dark, high-contrast background
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,

    config = function()
      vim.opt.termguicolors = true
      vim.opt.background = "dark"

      vim.g.everforest_background = "hard"
      vim.g.everforest_better_performance = 1

      vim.cmd.colorscheme("everforest")
    end,
  },


  -- ------------------------------------------------------------
  -- File Explorer
  -- ------------------------------------------------------------

  -- nvim-tree: https://github.com/nvim-tree/nvim-tree.lua
  -- Configure nvim-tree as a persistent sidebar without Nerd Font icons
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,

    opts = {
      -- Sidebar position and dimensions
      view = {
        side = "left",
        width = 35,
      },

      -- File and directory appearance
      renderer = {
        group_empty = true,

        indent_markers = {
          enable = true,
        },

        -- Disable icons to support standard terminal fonts
        icons = {
          show = {
            file = false,
            folder = false,
            folder_arrow = false,
            git = false,
            modified = false,
            diagnostics = false,
            bookmarks = false,
          },
        },
      },

      -- Display hidden and Git-ignored files
      filters = {
        dotfiles = false,
        git_ignored = false,
      },

      -- Follow the currently focused file in the tree
      update_focused_file = {
        enable = true,
      },

      -- Keep the sidebar open when selecting files
      actions = {
        open_file = {
          quit_on_open = false,

          -- Open files directly without prompting for a window
          window_picker = {
            enable = false,
          },
        },
      },
    },
  },


  -- ------------------------------------------------------------
  -- FZF
  -- ------------------------------------------------------------

  -- Use the core Vim integration installed by Homebrew
  {
    dir = "/opt/homebrew/opt/fzf",
    name = "fzf",
    lazy = false,
  },

  -- fzf.vim: https://github.com/junegunn/fzf.vim
  -- Provide fuzzy file, buffer, and text-search commands
  {
    "junegunn/fzf.vim",
    dependencies = { "fzf" },
    lazy = false,
  },


  -- ------------------------------------------------------------
  -- Git Integration
  -- ------------------------------------------------------------

  -- vim-fugitive: https://github.com/tpope/vim-fugitive
  -- Provide Git status, blame, staging, and other Git commands
  {
    "tpope/vim-fugitive",
  },


  -- ------------------------------------------------------------
  -- Surround
  -- ------------------------------------------------------------

  -- vim-surround: https://github.com/tpope/vim-surround
  -- Add, change, and remove surrounding characters
  -- Enable dot-repeat support for supported surround operations
  {
    "tpope/vim-surround",
    dependencies = {
      "tpope/vim-repeat",
    },
  },


  -- ------------------------------------------------------------
  -- Marks
  -- ------------------------------------------------------------

  -- vim-signature: https://github.com/kshenoy/vim-signature
  -- Display and navigate Vim marks in the sign column
  {
    "kshenoy/vim-signature",
    lazy = false,
  },


  -- ------------------------------------------------------------
  -- Language Server Protocol
  -- ------------------------------------------------------------

  -- nvim-lspconfig: https://github.com/neovim/nvim-lspconfig
  -- Provide standard language server configurations for native LSP
  {
    "neovim/nvim-lspconfig",
    lazy = false,
  },


  -- ------------------------------------------------------------
  -- Syntax Highlighting
  -- ------------------------------------------------------------

  -- nvim-treesitter: https://github.com/nvim-treesitter/nvim-treesitter
  -- Manage Treesitter parsers for supported languages
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
  },

  -- ansible-vim: https://github.com/pearofducks/ansible-vim
  -- Preserve traditional Ansible syntax highlighting
  {
    "pearofducks/ansible-vim",
    lazy = false,

    init = function()
      vim.g.ansible_extra_keywords_highlight = 1
    end,
  },


  -- ------------------------------------------------------------
  -- External Linting
  -- ------------------------------------------------------------

  -- nvim-lint: https://github.com/mfussenegger/nvim-lint
  -- Run external linters through Neovim's diagnostic interface
  {
    "mfussenegger/nvim-lint",
    lazy = false,
  },
}

-- vim: ft=lua ts=2 sts=2 sw=2 et
