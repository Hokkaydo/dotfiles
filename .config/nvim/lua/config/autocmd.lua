vim.api.nvim_create_autocmd('BufEnter', {
    desc = 'Set higher conceallevel on Markdown buffers',
    pattern = {'*.md'},
    group = vim.api.nvim_create_augroup('md-conceallevel', { clear = true }),
    callback = function()
        vim.opt_local.conceallevel = 2
    end
})

vim.api.nvim_create_autocmd('BufEnter', {
    desc = 'Set glsl filetype on .vert, .frag and .geom file extensions',
    pattern = {'*.frag', '*.geom', '*.vert'},
    group = vim.api.nvim_create_augroup('glsl-set-ft', { clear = true }),
    callback = function()
        vim.opt_local.ft = 'glsl'
    end
})

-- Adapted from kickstart.nvim
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight on yank',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function ()
        vim.highlight.on_yank({timeout = 80})
    end
})


vim.api.nvim_create_autocmd('TermOpen', {
    desc = "Disable line numbers in terminal",
    group = vim.api.nvim_create_augroup('terminal-line-numbers', { clear = true }),
    callback = function ()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end
})
