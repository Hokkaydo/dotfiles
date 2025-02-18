return {    
    {
        "navarasu/onedark.nvim",
        opts = {
            transparent = true,
            style = 'cool',
            term_colors = true,
            toggle_style_key = 'c',
            toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light', 'cool' },

            code_style = {
                comments = 'italic',
                keywords = 'italic',
                functions = 'none',
                strings = 'none',
                variables = 'none',
            },
            lualine = {
                transparent = false,
            },

        },
	    config = function(_, opts)
	        require("onedark").setup(opts)
	    end,
    },
    {
	    "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
	    opts = {
	        --style = "storm",
	        transparent = true,
	        styles = {
		        comments = { italic = true },
                sidebars = "transparent",
                floats = "transparent",
	        },
	    },
	    config = function(_, opts)
	        require("tokyonight").setup(opts)
	    end,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            theme = 'onedark',
        },
        config = function(_, opts)
            require('lualine').setup(opts)
        end,
    },
}
