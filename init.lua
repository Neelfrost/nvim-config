-- Author: Neel Basak
-- Github: https:/github.com/Neelfrost
-- File: init.lua

-- Paths
HOME_PATH = vim.fn.expand("$HOME")
CONFIG_PATH = vim.fn.stdpath("config")
PACKER_PATH = vim.fn.stdpath("data") .. "\\site\\pack\\packer"

-- Plugin filetypes
PLUGINS = { "NvimTree", "packer", "dashboard", "alpha" }

-- Linting icons
ICON_ERROR = "E"
ICON_WARN = "W"
ICON_INFO = "I"
ICON_HINT = "H"

-- General config
vim.cmd("source ~/AppData/Local/nvim/lua/utils.vim")
vim.cmd("source ~/AppData/Local/nvim/lua/autocommands.vim")
require("options")
require("utils")
require("mappings")
require("pluginlist")
