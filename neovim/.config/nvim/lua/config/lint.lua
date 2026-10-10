-- ------------------------------------------------------------
-- Linting
-- ------------------------------------------------------------

local lint = require("lint")


-- ------------------------------------------------------------
-- Linters by Filetype
-- ------------------------------------------------------------

-- Associate external linters with their respective filetypes
local linters_by_filetype = {
  bash = { "shellcheck" },
  dockerfile = { "hadolint" },
  jinja = { "j2lint" },
  json = { "json_tool" },
  markdown = { "markdownlint-cli2" },
  python = { "ruff" },
  sh = { "shellcheck" },
  terraform = { "tflint" },
  yaml = { "yamllint" },

  -- Specialized YAML filetypes
  ["yaml.ansible"] = { "ansible_lint" },
  ["yaml.cloudformation"] = { "cfn_lint" },
}

lint.linters_by_ft = linters_by_filetype


-- ------------------------------------------------------------
-- Python Virtual Environments
-- ------------------------------------------------------------

-- Prefer project-local executables from .venv, falling back to PATH
local function python_executable(name)
  -- Locate the project root using Python project markers
  local root = vim.fs.root(0, {
    "pyproject.toml",
    "uv.lock",
  })

  if root then
    local executable = vim.fs.joinpath(root, ".venv", "bin", name)

    -- Use the project's executable if available
    if vim.fn.executable(executable) == 1 then
      return executable
    end
  end

  -- Fall back to the globally available executable
  return name
end

-- Configure Ruff to use the project-local installation when available
lint.linters.ruff.cmd = function()
  return python_executable("ruff")
end


-- ------------------------------------------------------------
-- Lint Execution
-- ------------------------------------------------------------

-- Run the configured linters for the current buffer
local function run_linters()
  -- Skip special buffers such as terminals and help pages
  if vim.bo.buftype ~= "" then
    return
  end

  -- Skip unnamed buffers
  if vim.api.nvim_buf_get_name(0) == "" then
    return
  end

  -- Select linters for the current filetype
  local configured = linters_by_filetype[vim.bo.filetype]

  if not configured then
    return
  end

  -- Collect linters with available executables
  local available = {}

  for _, name in ipairs(configured) do
    local linter = lint.linters[name]

    if linter then
      -- Resolve dynamically configured linters
      if type(linter) == "function" then
        linter = linter()
      end

      local cmd = linter.cmd

      -- Resolve dynamically configured commands
      if type(cmd) == "function" then
        cmd = cmd()
      end

      -- Only include linters whose executables are available
      if type(cmd) == "string" and vim.fn.executable(cmd) == 1 then
        table.insert(available, name)
      end
    end
  end

  -- Run the available linters without modifying the file
  if #available > 0 then
    lint.try_lint(available)
  end
end


-- ------------------------------------------------------------
-- Autocommands
-- ------------------------------------------------------------

local group = vim.api.nvim_create_augroup("ExternalLinting", {
  clear = true,
})

-- Run external linters after saving a file
vim.api.nvim_create_autocmd("BufWritePost", {
  group = group,
  callback = run_linters,
  desc = "Lint file after saving",
})


-- ------------------------------------------------------------
-- Commands
-- ------------------------------------------------------------

-- Allow manual linting with :Lint
vim.api.nvim_create_user_command("Lint", run_linters, {
  desc = "Run configured linters",
})

-- vim: ft=lua ts=2 sts=2 sw=2 et
