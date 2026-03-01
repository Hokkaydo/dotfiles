return {
    "OXY2DEV/markview.nvim",
    lazy = false,

    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    opts = {
        preview = {
            icon_provider = "devicons",
            enable = true,
            modes = { "n", "i", "no", "c" },
            hybrid_modes = { "i" },
            filetypes = { "markdown" }
        },
    }
}
