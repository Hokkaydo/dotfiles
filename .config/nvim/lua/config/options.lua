local options = {
    clipboard = "unnamedplus",
    hlsearch = true,
    ignorecase = true,
    fileencoding = "utf-8",
    conceallevel = 2,           -- `` visible in markdown
    cmdheight = 2,
    mouse = "a",
    showmode = false,
    showtabline = 2,
    smartindent = true,
    swapfile = true,
    termguicolors = true,
    expandtab = true,
    shiftwidth = 4,
    tabstop = 4,
    numberwidth = 4,
    cursorline = true,
    number = true,
    relativenumber = true,
    signcolumn = "yes",
    wrap = true,
    linebreak = true,
    ttyfast = true,
    undofile = true,
    updatetime = 2000,
    scrolloff = 8,
    sidescrolloff = 8,
}

for k,v in pairs(options) do
    vim.opt[k] = v
end
