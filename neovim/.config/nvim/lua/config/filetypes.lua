-- ------------------------------------------------------------
-- Filetype Detection
-- ------------------------------------------------------------

-- Register custom filetypes based on filenames, paths, and contents
vim.filetype.add({
  -- ------------------------------------------------------------
  -- File Extensions
  -- ------------------------------------------------------------

  extension = {
    -- Jinja and Nunjucks templates
    j2 = "jinja",
    jinja = "jinja",
    jinja2 = "jinja",
    njk = "jinja",
    nunjucks = "jinja",
    nunjs = "jinja",
  },


  -- ------------------------------------------------------------
  -- Filename Patterns
  -- ------------------------------------------------------------

  pattern = {
    -- Ansible inventory variables
    [".*/group_vars/.*%.ya?ml"] = "yaml.ansible",
    [".*/host_vars/.*%.ya?ml"] = "yaml.ansible",

    -- Ansible playbooks and tasks
    [".*/playbook[^/]*%.ya?ml"] = "yaml.ansible",
    [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
    [".*/tasks/.*%.ya?ml"] = "yaml.ansible",

    -- Ansible roles
    [".*/roles/.*/defaults/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*/meta/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*/vars/.*%.ya?ml"] = "yaml.ansible",

    -- Ansible Molecule configuration
    [".*/molecule/.*%.ya?ml"] = "yaml.ansible",

    -- CloudFormation templates identified by filename
    [".*%.cfn%.ya?ml"] = {
      "yaml.cloudformation",
      { priority = 20 },
    },

    -- CloudFormation templates identified within the first five lines
    [".*%.ya?ml"] = {
      function(_, bufnr)
        if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end

        -- Allow YAML document markers, comments, and blank lines
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 5, false)

        for _, line in ipairs(lines) do
          if line:match("^%s*AWSTemplateFormatVersion%s*:") then
            return "yaml.cloudformation"
          end
        end
      end,
      { priority = 10 },
    },
  },
})

-- vim: ft=lua ts=2 sts=2 sw=2 et
