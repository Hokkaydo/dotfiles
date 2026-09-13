return {
    'folke/which-key.nvim',
    event = "VeryLazy",
    opts = {
        preset = "modern",
        spec = {
            { "<leader>f", group = "Find" },
            { "<leader>c", group = "Code" },
            { "<leader>o", group = "Obsidian" },
            { "<leader>b", group = "Debug" },
            { "<leader>x", group = "Diagnostics" },
            { "<leader>t", group = "Terminal" },
            { "<leader>l", group = "Ledger" },
        },
    },
}
