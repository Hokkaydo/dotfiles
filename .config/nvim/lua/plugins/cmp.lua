return {
    'hrsh7th/nvim-cmp',
    enabled = true,
    dependencies = {
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-cmdline' },
        { 'kirasok/cmp-hledger' },
        { "saadparwaiz1/cmp_luasnip" },
    },
    event = "InsertEnter",
    config = function()
        local cmp = require("cmp")

        cmp.setup({
            snippet = {
                expand = function(args)
                    vim.snippet.expand(args.body)
                end,
            },
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'path' },
                { name = 'hledger' },
                { name = "luasnip" },
            }, {
                { name = 'buffer' },
            }),
            mapping = {
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                -- Put Shift-Tab to select previous
                ['<S-Tab>'] = function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                    else
                        fallback()
                    end
                end,
            },
            experimental = {
                ghost_text = true     -- this feature conflict with copilot.vim's preview.
            },
        })
    end
}
