-- ------------------------------------------------------------
-- General
-- ------------------------------------------------------------

local opt = vim.opt

-- Editing
opt.backspace = { "indent", "eol", "start" } -- Allow backspacing over indentation, line breaks, and insert start
opt.confirm = true                          -- Prompt to save modified buffers before closing
opt.hidden = true                           -- Allow switching buffers without saving
opt.startofline = false                     -- Preserve cursor column when jumping between buffers

-- Indentation
opt.autoindent = true                       -- Copy indentation from the previous line
opt.expandtab = true                        -- Insert spaces instead of tab characters
opt.shiftwidth = 2                          -- Number of spaces used for indentation
opt.shiftround = true                       -- Round indentation to multiples of shiftwidth
opt.softtabstop = 2                         -- Number of spaces a Tab represents while editing
opt.tabstop = 2                             -- Display width of tab characters

-- File handling
opt.fileformats = { "unix", "dos", "mac" }   -- Prefer Unix line endings when detecting file formats

-- Completion
opt.complete:append("kspell")               -- Include spelling suggestions in keyword completion
opt.completeopt = { "menuone", "noselect" }  -- Display completion menu without preselecting an item

-- Dictionary
if vim.fn.filereadable("/usr/share/dict/words") == 1 then
  opt.dictionary:append("/usr/share/dict/words")
end

-- Searching
opt.hlsearch = true                         -- Highlight search matches
opt.ignorecase = true                       -- Ignore case when searching
opt.incsearch = true                        -- Show matches while typing a search
opt.smartcase = true                        -- Match case when search contains uppercase letters
opt.path = { ".", "**" }                    -- Search current directory and recursively for files

-- Use ripgrep for native :grep and :lgrep commands
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --no-heading --smart-case --hidden"
  opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- Spelling
opt.spell = false                           -- Disable spell checking by default
opt.spelllang = { "en_us" }                  -- Use American English for spell checking

-- Key timing
opt.timeout = true                          -- Enable timeout for mapped key sequences
opt.timeoutlen = 500                        -- Wait 500 ms for a mapping to complete

-- Mouse
-- opt.mouse = "a"                           -- Enable mouse support in all modes


-- ------------------------------------------------------------
-- Windows and Splits
-- ------------------------------------------------------------

opt.splitbelow = true                       -- Open horizontal splits below the current window
opt.splitright = true                       -- Open vertical splits to the right
opt.previewheight = 25                      -- Default height of preview windows
opt.signcolumn = "yes"                      -- Always display sign column to prevent text shifting


-- ------------------------------------------------------------
-- Folding
-- ------------------------------------------------------------

opt.foldmethod = "indent"                   -- Create folds based on indentation
opt.foldenable = false                      -- Leave folds open initially
opt.foldcolumn = "2"                        -- Reserve two columns for fold indicators


-- ------------------------------------------------------------
-- Visual Helpers
-- ------------------------------------------------------------

-- Command line
opt.cmdheight = 2                           -- Reserve two lines for the command area
opt.showcmd = true                          -- Display partially entered commands
opt.wildmenu = true                         -- Enable enhanced command-line completion
opt.wildmode = { "longest:full", "full" }     -- Complete longest match, then cycle through matches

-- Cursor and line numbers
opt.colorcolumn = "80"                      -- Highlight the 80th column
opt.cursorline = true                       -- Highlight the current line
opt.relativenumber = true                   -- Display line numbers relative to the cursor
opt.ruler = true                            -- Display cursor position in the status line

-- Whitespace
opt.list = true                             -- Display configured whitespace characters
opt.listchars = {
  tab = "» ",                               -- Tab characters
  extends = "›",                            -- Text extending beyond the right edge
  precedes = "‹",                           -- Text extending beyond the left edge
  nbsp = "·",                               -- Non-breaking spaces
  lead = ".",                               -- Leading spaces
  trail = "·",                              -- Trailing spaces
}

-- Messages
opt.shortmess:append("c")                   -- Suppress completion-related messages

-- Modelines
opt.modeline = true                         -- Allow file-specific settings in modelines
opt.modelines = 3                           -- Search the final three lines for modelines


-- ------------------------------------------------------------
-- Statusline
-- ------------------------------------------------------------

opt.laststatus = 2                          -- Always display the status line

opt.statusline = table.concat({
  "%f",                                     -- File path
  " ",
  "%y",                                     -- Filetype
  " ",
  "%{exists('*FugitiveStatusline') ? FugitiveStatusline() : ''}",
  " ",
  "%m",                                     -- Modified indicator
  "%*",                                     -- Restore default highlight group
  "%=",                                     -- Separate left- and right-aligned sections
  "%3c",                                    -- Cursor column
  " | ",
  "%l/%L",                                  -- Current line / total lines
  " ",
  "%p%%",                                   -- Percentage through file
})


-- ------------------------------------------------------------
-- Persistent Undo and File State
-- ------------------------------------------------------------

-- Preserve undo history between editing sessions
opt.undofile = true
opt.undolevels = 1000
opt.undoreload = 10000

-- Keep swap and write-backup protection enabled
opt.swapfile = true
opt.writebackup = true

-- Use ShaDa to preserve history, registers, and marks
opt.shada = "!,'100,<500,s10,h"

-- vim: ft=lua ts=2 sts=2 sw=2 et
