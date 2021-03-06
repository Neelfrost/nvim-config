-- Author: Neel Basak
-- Github: https:/github.com/Neelfrost
-- File: init.lua

-- Colorscheme
SCHEME = "nightlamp"

-- Language servers
SERVERS = { "pyright", "sumneko_lua", "omnisharp", "html", "cssls", "eslint", "emmet_ls" }

-- Treesitter parsers
PARSERS = { "comment", "python", "lua", "c_sharp", "html", "css", "javascript", "yaml", "json" }

-- Plugin filetypes
PLUGINS = { "packer", "alpha", "neo-tree" }

-- Paths
HOME_PATH = vim.fn.expand("$HOME")
CONFIG_PATH = vim.fn.stdpath("config")
PACKER_PATH = vim.fn.stdpath("data") .. "\\site\\pack\\packer"

-- Linting icons
ICON_ERROR = "E"
ICON_WARN = "W"
ICON_INFO = "I"
ICON_HINT = "H"

-- Improve startuptime using impatient
require("user.plugins.config.impatient")

-- Configuration files
vim.cmd("source ~/AppData/Local/nvim/viml/utils.vim")
vim.cmd("source ~/AppData/Local/nvim/viml/autocommands.vim")
require("user.autocmds")
require("user.options")
require("user.utils")
require("user.mappings")
require("user.plugins")
