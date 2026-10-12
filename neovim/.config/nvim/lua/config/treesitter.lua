-- ------------------------------------------------------------
-- Treesitter
-- ------------------------------------------------------------

local treesitter = require("nvim-treesitter")


-- ------------------------------------------------------------
-- Language Parsers
-- ------------------------------------------------------------

-- Install missing parsers automatically
local parsers = {
  "bash",
  "css",
  "diff",
  "dockerfile",
  "gitcommit",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "hcl",
  "html",
  "ini",
  "javascript",
  "jinja",
  "json",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "perl",
  "php",
  "python",
  "rust",
  "scss",
  "sql",
  "terraform",
  "toml",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
  "zsh",
}

treesitter.install(parsers)


-- ------------------------------------------------------------
-- Filetype Associations
-- ------------------------------------------------------------

-- Associate shell scripts with the Bash parser
vim.treesitter.language.register("bash", "sh")

-- Use Terraform highlighting for variable files
vim.treesitter.language.register("terraform", "terraform-vars")

-- Use YAML highlighting for CloudFormation templates
vim.treesitter.language.register("yaml", "yaml.cloudformation")


-- ------------------------------------------------------------
-- Syntax Highlighting
-- ------------------------------------------------------------

-- Derive supported filetypes from the installed parsers
-- Exclude parsers used only for embedded language highlighting
local filetypes = vim.tbl_filter(function(parser)
  return parser ~= "markdown_inline"
end, parsers)

-- Include filetypes that use another language's parser
vim.list_extend(filetypes, {
  "sh",
  "terraform-vars",
  "yaml.cloudformation",
})

local group = vim.api.nvim_create_augroup("TreesitterHighlight", {
  clear = true,
})

-- Enable syntax highlighting for supported filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = filetypes,
  callback = function(args)
    -- Preserve traditional Ansible syntax highlighting
    if vim.bo[args.buf].filetype == "yaml.ansible" then
      return
    end

    pcall(vim.treesitter.start, args.buf)
  end,
})

-- vim: ft=lua ts=2 sts=2 sw=2 et
