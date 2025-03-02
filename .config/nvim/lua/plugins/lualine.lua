return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
            options = {
                icons_enabled = false,
                theme = 'palenight',
                component_separators = { left = '', right = ''},
                section_separators = { left = '', right = ''},
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = true,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                }
            },
            sections = {
                lualine_a = {'hostname', 'mode'},
                lualine_b = {'branch', 'diff'},
                lualine_c = {'filename'},
                lualine_x = {'filetype'},
                lualine_y = {'progress'},
                lualine_z = {'location', 'searchcount' },
                -- To get the current function
                -- function ()
                --     return require("nvim-treesitter.statusline").statusline({
                        -- indicator_size = 100,
                        -- type_patterns = {'class', 'function', 'method'},
                        -- transform_fn = function(line, _node) return line:gsub('%s*[%[%(%{]*%s*$', '') end,
                        -- separator = ' -> ',
                        -- allow_duplicates = false
                    --  })
                -- end}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'filename'},
                lualine_x = {'location'},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {'oil', 'quickfix'}
        }
}
