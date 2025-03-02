return {
    "ibhagwan/fzf-lua",
    enabled = false,
    keys = {
        {
            '<leader>ff',
            function()
                require('fzf-lua').files({ resume = true })
            end,
            expr = true,
            desc = "[F]ind [F]iles"
        },
        {
            '<leader>fg',
            function()
                require('fzf-lua').git_files({ resume = true })
            end,
            expr = true,
            desc = "[F]ind [G]it files"
        },
        {
            '<leader>fb',
            function()
                require('fzf-lua').buffers({ resume = true })
            end,
            expr = true,
            desc = "[F]ind [B]uffers"
        },
        {
            '<leader>fr',
            function()
                require('fzf-lua').grep({ resume = true })
            end,
            expr = true,
            desc = "[F]ind [R]egular expression"
        },
    },
    opts={
        'telescope',
        winopts = { height=0.33, width=0.33 }
    }
}
