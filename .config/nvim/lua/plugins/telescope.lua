return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies={
        'nvim-lua/plenary.nvim',
    },
    keys = {
        {'<leader>ff', "<cmd>Telescope find_files<CR>"},     -- [f]ind [f]iles
        {'<leader>fp', "<cmd>Telescope git_files<CR>"},      -- [f]ind in [p]roject
        {'<leader>fg', "<cmd>Telescope live_grep<CR>"},      -- [f]ind by [g]rep
        {'<leader>fr', "<cmd>Telescope resume<CR>"},      -- [f]ind [r]esumes
        {'<leader>fb', "<cmd>Telescope buffers<CR>"},        -- [f]ind [b]uffer
    },

    opts={
        defaults = {
            mappings = {
                i = {
                    ['<C-k>'] = "move_selection_previous",
                    ['<C-j>'] = "move_selection_next",
                }
            }
        }
    }
}
