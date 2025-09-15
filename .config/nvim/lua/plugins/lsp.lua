return {
    -- lsp-zero is not required to setup language servers
    -- BUT : lsp-zero's documentation is very valuable.
    -- {
    --     'VonHeikemen/lsp-zero.nvim', branch = "v4.x",
    -- },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { "williamboman/mason.nvim",           lazy = false },
            { "williamboman/mason-lspconfig.nvim", lazy = false },
            { 'hrsh7th/nvim-cmp', lazy=false }
            -- { 'saghen/blink.cmp', lazy = false },
        },

        config = function()
            -- ================== Options and custom commands =================
            vim.g.lsp_preview_max_width = 200
            -- Reserve a space in the gutter
            -- This will avoid an annoying layout shift in the screen
            vim.opt.signcolumn = 'yes'

            -- ===================== lspconfig setup ==========================
            local lspconfig = require('lspconfig')

            -- setup keymaps
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local opts = { buffer = event.buf }

                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'grf', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', 'grn', vim.lsp.buf.rename, opts)
                end,
            })

            
            -- ======================= mason setup ============================
            -- local capabilities = require('blink.cmp').get_lsp_capabilities() 
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            require('mason').setup({})
            require('mason-lspconfig').setup({
                -- Replace the language servers listed here
                -- with the ones you want to install
                ensure_installed = { 'clangd', 'cmake', 'lua_ls', 'html', 'rust_analyzer', 'pyright', 'asm_lsp', 'cssls', 'ltex' },
                automatic_installation = true,
                handlers = {
                    function(server_name)
                        lspconfig[server_name].setup({ capabilities = capabilities })
                    end,
                },
            })
        end
    },
}
