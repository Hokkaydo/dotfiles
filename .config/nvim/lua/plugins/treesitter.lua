return {
    'nvim-treesitter/nvim-treesitter',
    branch = "main",
    build = ':TSUpdate',
    lazy = false,
    config = function()
        require("nvim-treesitter").setup({
            ensure_installed = { "c", "ledger", "lua", "vim", "cpp", "python", "bash", "csv", "vimdoc", "query", "markdown", "rust", "hyprlang", "html", "json", "css" },
            sync_install = false,
            auto_install = false,
        })

        -- Disable treesitter highlight for latex, use regex instead
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "latex",
            callback = function()
                vim.treesitter.stop()
                vim.cmd("syntax on")
            end,
        })
    end
}
