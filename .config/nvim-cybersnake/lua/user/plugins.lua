local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    print("Installing packer close and reopen Neovim...")
    vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerSync
augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})

require("tokyonight").setup({
    style="storm",
    transparent="true",
    styles ={
        comments = { italic = true, fg="#00d100"},
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "transparent",
        floats = "transparent"
    },
    hl_styles = {
        floats = "transparent",
        sidebars = "default"
    },
    --sidebars = {"qf", "vista_kind", "terminal", "packer"},
    on_colors = function(colors)
        colors.hint = colors.orange
        colors.error = "#ff0000"
        colors.fg_gutter = "#212121"
        
    end,
    on_highlights = function(hl, c)
        hl.CursorLineNr = { fg = c.orange, bold = true}
        hl.LineNr = { fg = c.orange, bold = true}
        hl.LineNrAbove = { fg = c.fg_gutter }
        hl.LineNrBelow = { fg = c.fg_gutter }


        hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark}
    end
})

require("tailwind-tools").setup({

})

require('lspconfig').tailwindcss.setup({

}) 

-- Install your plugins here
return packer.startup(function(use)
    use { "wbthomason/packer.nvim", } -- Have packer manage itself
    use { "windwp/nvim-autopairs", } -- Autopairs, integrates with both cmp and treesitter
    use { "JoosepAlviste/nvim-ts-context-commentstring", }
    use { "akinsho/bufferline.nvim", }
    use { "moll/vim-bbye",}
    use { "nvim-lualine/lualine.nvim", }
    use { "akinsho/toggleterm.nvim", }
    use { "ahmedkhalf/project.nvim", }
    use { "lewis6991/impatient.nvim", }
    use { "lukas-reineke/indent-blankline.nvim",}
    use { "goolord/alpha-nvim", }
    use {"folke/which-key.nvim"}
    use {"folke/tokyonight.nvim", lazy = false, priority = 1000, opts ={}}

    -- Colorschemes
    use { 'Shatur/neovim-ayu',
    as = 'ayu-dark',
    config = function()
         vim.cmd('colorscheme tokyonight-night')
    end }

    -- Cmp 
    use { "hrsh7th/nvim-cmp",} -- The completion plugin
    use { "hrsh7th/cmp-buffer",} -- buffer completions
    use { "hrsh7th/cmp-path",} -- path completions
    use { "saadparwaiz1/cmp_luasnip", } -- snippet completions
    use { "hrsh7th/cmp-nvim-lsp", }
    use { "hrsh7th/cmp-nvim-lua", }

    -- Snippets
    use { "L3MON4D3/LuaSnip", } --snippet engine
    use { "rafamadriz/friendly-snippets", } -- a bunch of snippets to use

    -- LSP
    use { "neovim/nvim-lspconfig", } -- enable LSP
    use { "williamboman/mason.nvim",} -- simple to use language server installer
    use { "williamboman/mason-lspconfig.nvim", }
    use { "jose-elias-alvarez/null-ls.nvim", } -- for formatters and linters
    use { "RRethy/vim-illuminate", }
    use {"luckasRanarison/tailwind-tools.nvim"}

    -- Telescope
    use { "nvim-telescope/telescope.nvim", }

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",}


        -- Markdown Preview
        -- install without yarn or npm
        use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })

-- Neo-Tree
use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    requires = { 
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    }
}



        if PACKER_BOOTSTRAP then
            require("packer").sync()
        end
    end)


