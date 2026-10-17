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
      -- Configure file explorer keybindings
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        -- Preserve default nvim-tree mappings
        api.map.on_attach.default(bufnr)

        -- Restore native Vim navigation (top, middle, bottom)
        for _, key in ipairs({ "H", "M", "L" }) do
          vim.keymap.del("n", key, { buffer = bufnr })
        end

        -- Toggle hidden files with zh instead of H
        vim.keymap.set("n", "zh", api.filter.dotfiles.toggle, {
          buffer = bufnr,
          desc = "Toggle dotfiles",
          silent = true,
        })
      end,

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
  -- Formatting
  -- ------------------------------------------------------------

  -- conform: https://github.com/stevearc/conform.nvim
  -- Format selected filetypes with external formatters
  {
    "stevearc/conform.nvim",

    opts = {
      -- Format only explicitly selected filetypes
      formatters_by_ft = {
        bash = { "shfmt" },
        css = { "prettier" },
        go = { "gofmt" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        python = { "ruff_format" },
        rust = { "rustfmt" },
        scss = { "prettier" },
        sh = { "shfmt" },
        terraform = { "tofu_fmt" },
        ["terraform-vars"] = { "tofu_fmt" },
        zsh = { "shfmt" },
      },

      -- Use project settings first, then personal XDG defaults
      formatters = {
        prettier = {
          prepend_args = function(_, ctx)
            local config_home = vim.env.XDG_CONFIG_HOME
              or (vim.env.HOME .. "/.config")
            local config = config_home .. "/prettier/config.yaml"

            -- Check whether Prettier can find a project configuration
            local result = vim.fn.systemlist({
              "prettier",
              "--find-config-path",
              ctx.filename,
            })

            if vim.v.shell_error == 0 and #result > 0 then
              return {}
            end

            -- Fall back to the personal configuration
            if vim.fn.filereadable(config) == 1 then
              return { "--config", config }
            end

            -- Otherwise use Prettier's defaults
            return {}
          end,
        },

        shfmt = {
          append_args = {
            "-ci",
            "-sr",
          },
        },
      },
    },
  },


  -- ------------------------------------------------------------
  -- Fuzzy Finding
  -- ------------------------------------------------------------

  -- fzf: https://github.com/junegunn/fzf
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
  -- Keybinding Help
  -- ------------------------------------------------------------

  -- which-key: https://github.com/folke/which-key.nvim
  -- Display available keybindings after a configurable delay
  {
    "folke/which-key.nvim",
    event = "VeryLazy",

    opts = {
      -- Wait before displaying available keybindings
      delay = 750,
      show_help = false,

      -- Disable mapping icons and use text for special keys
      icons = {
        mappings = false,
        keys = {
          BS = "BS",
          Esc = "Esc",
          Space = "leader",
        },
      },

      -- Display Space as leader
      replace = {
        key = {
          { "<Space>", "leader" },
        },
      },
    },
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
  -- Linting
  -- ------------------------------------------------------------

  -- nvim-lint: https://github.com/mfussenegger/nvim-lint
  -- Run external linters through Neovim's diagnostic interface
  {
    "mfussenegger/nvim-lint",
    lazy = false,
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
  -- Syntax Highlighting
  -- ------------------------------------------------------------

  -- ansible-vim: https://github.com/pearofducks/ansible-vim
  -- Preserve traditional Ansible syntax highlighting
  {
    "pearofducks/ansible-vim",
    lazy = false,

    init = function()
      vim.g.ansible_extra_keywords_highlight = 1
    end,
  },

  -- nvim-treesitter: https://github.com/nvim-treesitter/nvim-treesitter
  -- Manage Treesitter parsers for supported languages
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
  },
}

-- vim: ft=lua ts=2 sts=2 sw=2 et
