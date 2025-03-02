-- Activate line numbers
vim.opt.number = true

-- Activate relative number
-- vim.opt.relativenumber = true

-- Make the fringe a little smaller
vim.opt.numberwidth = 2

-- About tabs and width
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- better indents
vim.opt.smartindent = true

-- undo your entire life
vim.opt.undofile = true

-- highlight before you end your search
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- better colors
vim.opt.termguicolors = true

vim.opt.signcolumn = "yes"

-- Add the 80 lines, because you never know if we're rolling back to punchcards
vim.opt.colorcolumn = "80"

-- Only and always one status bar for everything
vim.opt.laststatus = 3

-- sync OS and nvim clipboard
vim.opt.clipboard = 'unnamedplus'

-- Better completion experience
vim.opt.completeopt = 'menuone,noselect,preview'

-- Don't show the mode in the bottom, it's already in the status bar (lualine)
vim.opt.showmode = false

-- Keep a number of lines above/below the cursor
vim.opt.scrolloff = 8

-- Keep the indentation on wrapped lines
vim.opt.breakindent = true

-- Highlight the current line and number
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'line,number'

-- Preview the out of window substitutions in another view
vim.opt.inccommand = 'split'

-- Help with :make command for gcc
vim.g.compiler_gcc_ignore_unmatched_lines = true
