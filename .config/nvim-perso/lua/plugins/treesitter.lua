return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = { 
                "c", 
                "lua", 
                "vim", 
                "vimdoc", 
                "markdown", 
                "markdown_inline", 
                "java", 
                "javascript", 
                "rust", 
                "html", 
                "css", 
                "python", 
                "latex", 
                "bash", 
                "hyprlang", 
                "json" 
            },
            auto_install = true,

            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        },
        config = function()
            require("nvim-treesitter").setup()
        end,
    }
}
