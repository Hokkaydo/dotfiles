-- Rebind leader to SPACE at init, just to be sure it's applied to everything
vim.g.mapleader = " "

-- Make leader a no-op
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Allow movement keys to jump through each line of a word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { desc = "Better Movements (up)", expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { desc = "Better Movements (down)", expr = true, silent = true })

-- Allow to move block of highlighted text around with alt+j/k
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move highlighted text down" })
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move highlighted text up" })

-- Move easily between windows
vim.keymap.set({ "n", "v", "i", "t" }, "<C-h>", "<cmd>wincmd h<CR>", { desc = "Move to left pane" })
vim.keymap.set({ "n", "v", "i", "t" }, "<C-j>", "<cmd>wincmd j<CR>", { desc = "Move to down pane" })
vim.keymap.set({ "n", "v", "i", "t" }, "<C-k>", "<cmd>wincmd k<CR>", { desc = "Move to up pane" })
vim.keymap.set({ "n", "v", "i", "t" }, "<C-l>", "<cmd>wincmd l<CR>", { desc = "Move to right pane" })

-- Snippet keymaps
vim.keymap.set({ 'i', 's' }, '<C-n>',
    function()
        if vim.snippet.active({ direction = 1 }) then
            vim.snippet.jump(1)
        end
    end,
    { desc = "Jump to the next snippet placeholder" }
)
vim.keymap.set({ 'i', 's' }, '<C-p>',
    function()
        if vim.snippet.active({ direction = -1 }) then
            vim.snippet.jump(-1)
        end
    end,
    { desc = "Jump to the previous snippet placeholder" }
)

-- Disable highlighting of search pattern
vim.keymap.set("n", "<escape>", vim.cmd.nohls, { desc = "Stop highlighting of search patterns" })

-- Pop a terminal below
-- TODO : Make it persistent (load it once and then hide/show it)
vim.keymap.set("n", "<leader>tt",
    function ()
        vim.cmd.vsplit()     -- pop a buffer
        vim.cmd.wincmd("J")  -- put the buffer on the bottom of the window
        vim.cmd.term()       -- transform it into a terminal
        vim.api.nvim_win_set_height(0, 5)   -- change the height
    end,
    { desc = "Pop a terminal on a new window on the bottom of the screen" }
)

-- Quickly register a ledger transaction
vim.keymap.set("n", "<leader>la",
    function ()
        vim.cmd.vsplit()
        vim.cmd.wincmd("L")
        vim.cmd.edit(os.date("~/finances/%Y/%Y.journal"))
    end,
    { desc = "Pop the current journal file" }
)

-- run "make"
vim.keymap.set("n", "<leader>cc", vim.cmd.make, { desc = "[C]ode [C]ompile"})
-- open the quickfix list
vim.keymap.set("n", "<leader>ce", vim.cmd.copen, { desc = "[C]ode [E]rrors"})
-- jump to next entry in qflist
vim.keymap.set("n", "<leader>cn", vim.cmd.cnext, { desc = "[C]ode [N]ext error"})
-- jump to previous entry in qflist
vim.keymap.set("n", "<leader>cp", vim.cmd.cprev, { desc = "[C]ode [P]revious error"})
