return {
    'nvim-telescope/telescope.nvim',
    branch = 'master',
    dependencies={
        'nvim-lua/plenary.nvim',
    },
    keys = {
        {'<leader>ff', "<cmd>Telescope find_files<CR>", desc = "[F]ind [F]iles"},
        {'<leader>fp', "<cmd>Telescope git_files<CR>", desc = "[F]ind in [P]roject (git files)"},
        {'<leader>fg', "<cmd>Telescope live_grep<CR>", desc = "[F]ind by [G]rep"},
        {'<leader>fr', "<cmd>Telescope resume<CR>", desc = "[F]ind [R]esume last search"},
        {'<leader>fb', "<cmd>Telescope buffers<CR>", desc = "[F]ind [B]uffer"},
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
