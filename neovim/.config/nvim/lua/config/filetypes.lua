-- ------------------------------------------------------------
-- Filetype Detection
-- ------------------------------------------------------------

-- Register custom filetypes based on filenames and file contents
vim.filetype.add({
  pattern = {
    -- CloudFormation templates identified by filename
    [".*%.cfn%.yaml"] = "yaml.cloudformation",
    [".*%.cfn%.yml"] = "yaml.cloudformation",

    -- CloudFormation templates identified by their first line
    [".*%.ya?ml"] = {
      function(_, bufnr)
        local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""

        if first_line:match("^AWSTemplateFormatVersion:") then
          return "yaml.cloudformation"
        end
      end,
      { priority = 10 },
    },

    -- Jinja and Nunjucks templates
    [".*%.jinja2"] = "jinja",
    [".*%.j2"] = "jinja",
    [".*%.jinja"] = "jinja",
    [".*%.nunjucks"] = "jinja",
    [".*%.nunjs"] = "jinja",
    [".*%.njk"] = "jinja",

    -- Mutt temporary message files
    [".*/?mutt%-.*"] = "mail",

    -- Calcurse notes and temporary files
    [".*/calcurse.*"] = "markdown",
    [".*/%.calcurse/notes.*"] = "markdown",
  },
})

-- vim: ft=lua ts=2 sts=2 sw=2 et
