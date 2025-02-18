return {
    { "neovim/nvim-lspconfig" },
    { 
        "williamboman/mason.nvim", config = function() require("mason").setup() end},
    { 
        "williamboman/mason-lspconfig.nvim", 
        config = function() 
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "pyright",
                    "rust_analyzer",
                    "grammarly",
                    "ltex",
                    "ts_ls", 
                    "html", 
                    "cssls",
                },
                automatic_installation = true,
            }) 
        end,
    },
    { "jose-elias-alvarez/null-ls.nvim" },
    { "luckasRanarison/tailwind-tools.nvim" }
}

