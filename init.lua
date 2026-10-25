
-- Neovim 0.12+ | modular configuration
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.filetypes")
require("config.autocmds")
require("config.commands")
require("config.lazy")
require("config.keymaps")
