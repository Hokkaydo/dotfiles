return {
    'folke/trouble.nvim',
    cmd = "Trouble",
    keys = {
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "[X] Diagnostics (all)" },
        { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "[X] Diagnostics (buffer)" },
        { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "[X] Quickfix list" },
        { "<leader>xr", "<cmd>Trouble lsp_references toggle<CR>", desc = "[X] LSP References" },
    },
    opts = {},
}
