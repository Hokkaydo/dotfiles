return {
    {
        'wilmanbarrios/palenight.nvim',
        lazy=false,
        config = function()
            vim.cmd([[colorscheme palenight]])
        end,
        priority=1000
    },
}
