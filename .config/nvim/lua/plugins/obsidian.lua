return {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = {
        -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
        -- refer to `:h file-pattern` for more examples
        "BufReadPre " .. vim.fn.expand "~" .. "/obsidian/Personal/second-brain/*.md",
        "BufNewFile " .. vim.fn.expand "~" .. "/obsidian/Personal/second-brain/*.md",
    },
    keys = {
        {"<leader>on", "<cmd>ObsidianNew<CR>", mode="n", desc="Create a new Obsidian note"},
        {"<leader>os", "<cmd>ObsidianQuickSwitch<CR>", mode="n", desc="Select and open an Obsidian note"},
        {"<leader>of", "<cmd>ObsidianSearch<CR>", mode="n", desc="Grep string in Obsidian vaults"},
    },
    dependencies = {
        -- Required.
        "nvim-lua/plenary.nvim",
    },
    opts = {
        workspaces = { {
            name = "Notes",
            path = "~/obsidian/Personal",
        } },

        completion = {
            nvim_cmp = true,
            min_chars = 2,
        },

        mappings = {
            -- Smart action depending on context, either follow link or toggle checkbox.
            ["<cr>"] = {
                action = function()
                    return require("obsidian").util.smart_action()
                end,
                opts = { buffer = true, expr = true },
            }
        },

        ---@param url string
        follow_url_func = function(url)
            -- Open the URL in the default web browser.
            vim.fn.jobstart({"xdg-open", url})  -- linux
            -- vim.ui.open(url) -- need Neovim 0.10.0+
        end,

        picker = {
            -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
            name = "telescope.nvim",
            -- Optional, configure key mappings for the picker. These are the defaults.
            -- Not all pickers support all mappings.
            note_mappings = {
                -- Create a new note from your query.
                new = "<C-x>",
                -- Insert a link to the selected note.
                insert_link = "<C-l>",
            },
        },
        -- Optional, customize how note IDs are generated given an optional title.
        ---@param title string|?
        ---@return string
        note_id_func = function(title)
            -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
            -- In this case a note with the title 'My new note' will be given an ID that looks
            -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
            local name = ""
            if title ~= nil then
                -- If title is given, transform it into valid file name.
                name = title:gsub("[^ A-Za-z0-9-]", "")
            else
                -- If title is nil, just add 4 random uppercase letters to the suffix.
                local time = tostring(os.time())
                for _ = 1, 4 do
                    name = name .. string.char(math.random(65, 90))
                end
                name = time .. name
            end
            return name
        end,
        -- Optional, determines how certain commands open notes. The valid options are:
        -- 1. "current" (the default) - to always open in the current window
        -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
        -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
        open_notes_in = "vsplit",
    },
}
