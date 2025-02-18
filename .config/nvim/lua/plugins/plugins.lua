return {

    -- Autocompletion
    { 
        "hrsh7th/nvim-cmp",          -- completion plugin
        opts = {
            sources = {
                { name = "nvim_lsp" },
                { name = "buffer", keyword_length = 5 },
                { name = "luasnip" },
            }
        },
        config = function(_, opts)
            require("cmp").setup(opts)
        end,
    },     
    { "hrsh7th/cmp-buffer" },   -- buffer completions
    { "hrsh7th/cmp-path" },     -- path completions
    { "saadparwaiz1/cmp_luasnip" },  -- snippet completions
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lua" },

    { "neoclide/coc.nvim", branch="release" },

    -- Snippets
    { "L3MON4D3/LuaSnip" }, -- snippet engine
    { "rafamadriz/friendly-snippets" }, -- bunch of snippets


    -- Telescope
    { "nvim-telescope/telescope.nvim" },

    -- Git
    { 
        "lewis6991/gitsigns.nvim",          -- git +/-/~ in border
        config = function()
            require("gitsigns").setup()
        end,
    },
    { "tpope/vim-fugitive" },                -- git wrapper
   
    -- Left sidebar 
    { 
	    "nvim-neo-tree/neo-tree.nvim",
	    dependencies = {
	        "nvim-lua/plenary.nvim",
	        "nvim-tree/nvim-web-devicons",
	        "MunifTanjim/nui.nvim",
	        "3rd/image.nvim",
	    }
    },

    -- Obsidian
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        lazy = true,
        ft = "markdown",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { workspaces = { { name = "Personal", path = "~/obsidian" } }, },
        config = function(_, opts)
            require("obsidian").setup(opts)
        end
    },

}
