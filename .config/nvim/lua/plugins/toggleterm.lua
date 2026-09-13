return {
    'akinsho/toggleterm.nvim',
    version = "*",
    keys = {
        { "<leader>tt", desc = "Toggle floating terminal" },
    },
    opts = {
        open_mapping = [[<leader>tt]],
        direction = "horizontal",
        size = 15,
        close_on_exit = true,
        start_in_insert = true,
    }
}
