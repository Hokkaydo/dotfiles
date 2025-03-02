return {
    'saghen/blink.cmp',

    -- optional: provides snippets for the snippet source
    -- dependencies = 'rafamadriz/friendly-snippets',

    enabled = false,
    version = 'v0.8.2',
    opts = {
        keymap = {
            preset = 'default',
            ['<CR>'] = { 'select_and_accept' , 'fallback' },
            ['<S-Tab>'] = { 'select_prev', 'fallback' },
            ['<Tab>'] = { 'select_next', 'fallback' },

            -- show with a list of providers
            ['<C-space>'] = { function(cmp) cmp.show({ providers = { 'snippets' } }) end },

            -- optionally, define different keymaps for cmdline
            -- cmdline = {
            --     preset = 'super-tab'
            -- }
        },
        snippets = {
            expand = function(snippet) vim.snippet.expand(snippet) end,
            active = function(filter) return vim.snippet.active(filter) end,
            jump = function(direction) vim.snippet.jump(direction) end,
        },

        completion = {
            list = {
                -- Controls how the completion items are selected
                -- 'preselect' will automatically select the first item in the completion list
                -- 'manual' will not select any item by default
                -- 'auto_insert' will not select any item by default, and insert the completion items automatically
                -- when selecting them
                selection = 'manual',
            },
            -- Displays a preview of the selected item on the current line
            ghost_text = {
                enabled = true,
            },
        },
        appearance = {
            -- Sets the fallback highlight groups to nvim-cmp's highlight groups
            -- Useful for when your theme doesn't support blink.cmp
            -- will be removed in a future release
            -- use_nvim_cmp_as_default = true,
            -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono'
        },

        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
            min_keyword_length = 2,
        },

        signature = { enabled = true }
    },
    -- allows extending the providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { "sources.default" }
}
