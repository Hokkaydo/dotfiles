-- General setup of vim.opt.
require("config.options")

-- Definition of keymaps 
-- WARNING : Must be loaded before any plugins/commands  
--           because it sets the global leader key
require("config.keymaps")

-- Plugin manager
require("config.lazy")

-- Personal autocmd
require("config.autocmd")

-- Personal user commands
require("config.commands")

print("Aight, here we go again")
