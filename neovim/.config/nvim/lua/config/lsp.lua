-- ------------------------------------------------------------
-- Ansible Language Server
-- ------------------------------------------------------------

-- Limit Ansible language support to specialized YAML files
vim.lsp.config("ansiblels", {
  filetypes = {
    "yaml.ansible",
  },

  settings = {
    ansible = {
      -- Use the system Ansible installation
      ansible = {
        path = "ansible",
      },

      -- Do not use Ansible execution environments
      executionEnvironment = {
        enabled = false,
      },

      -- Keep Ansible validation without duplicating ansible-lint
      validation = {
        enabled = true,
        lint = {
          enabled = false,
        },
      },
    },
  },
})


-- ------------------------------------------------------------
-- CloudFormation Language Server
-- ------------------------------------------------------------

-- CloudFormation uses AWS's standalone language server
-- Configure the executable path before enabling this server
local cloudformation_server = vim.fn.exepath("cfn-lsp-server-standalone")

if cloudformation_server ~= "" then
  vim.lsp.config("cloudformation_ls", {
    cmd = {
      "node",
      cloudformation_server,
      "--stdio",
    },

    filetypes = {
      "yaml.cloudformation",
    },

    root_markers = {
      ".git",
    },
  })
end


-- ------------------------------------------------------------
-- Docker Language Server
-- ------------------------------------------------------------

-- Provide Dockerfile completion and diagnostics
vim.lsp.config("dockerls", {
  filetypes = {
    "dockerfile",
  },
})


-- ------------------------------------------------------------
-- Lua Language Server
-- ------------------------------------------------------------

-- Configure Lua language support for Neovim
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      -- Use Neovim's LuaJIT runtime
      runtime = {
        version = "LuaJIT",
      },

      -- Recognize Neovim's global API
      diagnostics = {
        globals = { "vim" },
      },

      -- Include Neovim runtime definitions
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    },
  },
})


-- ------------------------------------------------------------
-- Terraform Language Server
-- ------------------------------------------------------------

-- Provide Terraform completion, navigation, and diagnostics
vim.lsp.config("terraformls", {
  filetypes = {
    "terraform",
    "terraform-vars",
  },
})


-- ------------------------------------------------------------
-- YAML Language Server
-- ------------------------------------------------------------

-- Handle ordinary YAML without attaching to Ansible or CloudFormation
vim.lsp.config("yamlls", {
  filetypes = {
    "yaml",
  },

  settings = {
    yaml = {
      -- Leave formatting to dedicated tools
      format = {
        enable = false,
      },

      -- Allow YAML schemas to provide validation and completion
      validate = true,
      completion = true,
      hover = true,
    },
  },
})


-- ------------------------------------------------------------
-- Language Servers
-- ------------------------------------------------------------

-- Enable language servers with standard nvim-lspconfig definitions
vim.lsp.enable({
  "ansiblels",
  "dockerls",
  "lua_ls",
  "terraformls",
  "ty",
  "yamlls",
})

-- Enable CloudFormation only when its executable is available
if cloudformation_server ~= "" then
  vim.lsp.enable("cloudformation_ls")
end


-- ------------------------------------------------------------
-- Diagnostics
-- ------------------------------------------------------------

-- Configure diagnostic display for LSP and external linters
vim.diagnostic.config({
  virtual_text = true,     -- Display diagnostics beside affected lines
  signs = true,            -- Show diagnostic indicators in the sign column
  underline = true,        -- Underline problematic text
  severity_sort = true,    -- Prioritize errors over warnings and hints
})

-- vim: ft=lua ts=2 sts=2 sw=2 et
