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
            { "WhoIsSethDaniel/mason-tool-installer.nvim", lazy = false },
            { 'hrsh7th/nvim-cmp', lazy=false }
            -- { 'saghen/blink.cmp', lazy = false },
        },

        config = function()
            -- ================== Options and custom commands =================
            vim.g.lsp_preview_max_width = 200
            -- Reserve a space in the gutter
            -- This will avoid an annoying layout shift in the screen
            vim.opt.signcolumn = 'yes'

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
            -- mason-lspconfig (v2+) no longer uses the classic
            -- ensure_installed + handlers + lspconfig.setup() pattern.
            -- It installs servers via Mason then calls Neovim's native
            -- vim.lsp.config()/vim.lsp.enable() (0.11+) under the hood, so
            -- per-server overrides must go through vim.lsp.config() too.
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            vim.lsp.config('*', { capabilities = capabilities })

            -- ltex-ls crashes on startup with newer JDKs: LanguageTool's
            -- English grammar.xml exceeds Java's default JAXP entity-size
            -- guard (jdk.xml.totalEntitySizeLimit). Raise it via JAVA_OPTS,
            -- which the ltex-ls launcher script forwards to the JVM.
            vim.lsp.config('ltex', {
                cmd_env = {
                    JAVA_OPTS = "-Djdk.xml.totalEntitySizeLimit=0 -Djdk.xml.entityExpansionLimit=0",
                },
            })

            -- Replace the language servers listed here
            -- with the ones you want to install
            local servers = { 'clangd', 'cmake', 'lua_ls', 'html', 'rust_analyzer', 'pyright', 'asm_lsp', 'cssls', 'ltex', 'bashls' }

            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = servers,
                -- automatic_enable defaults to enabling EVERY installed Mason
                -- package that happens to have a matching lspconfig name --
                -- including formatter-only tools like `stylua` (which also
                -- ships an `--lsp` mode) that we install below purely for
                -- conform.nvim. Scope it to our actual server list so those
                -- don't get silently enabled as LSP clients.
                automatic_enable = servers,
            })

            -- Non-LSP tools (formatters used by conform.nvim) installed via mason's own registry
            require('mason-tool-installer').setup({
                ensure_installed = { 'stylua', 'shfmt', 'clang-format' },
            })
        end
    },
}
