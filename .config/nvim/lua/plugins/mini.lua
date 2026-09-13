return {
    'echasnovski/mini.nvim',
    event = "VeryLazy",
    config = function()
        -- Replaces vim-surround: ys<motion><char> add, ds<char> delete, cs<char><char> change
        require('mini.surround').setup()

        -- Autoclose brackets/quotes as you type
        require('mini.pairs').setup()

        -- gc<motion>/gcc to toggle comments, treesitter-aware commentstring
        require('mini.comment').setup()

        -- Better a/i text objects (f = function call, a = argument, etc.), treesitter-aware
        require('mini.ai').setup()
    end
}
