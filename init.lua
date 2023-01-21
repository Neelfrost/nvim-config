-- Author: Neel Basak
-- Github: https:/github.com/Neelfrost
-- File: init.lua

-- Colorscheme
SCHEME = "nightlamp"

-- Language servers
SERVERS = { "pyright", "sumneko_lua", "omnisharp", "html", "cssls", "eslint", "emmet_ls" }

-- Treesitter parsers
PARSERS = { "comment", "python", "lua", "c_sharp", "html", "css", "javascript", "yaml", "json", "markdown", "vim" }

-- Plugin filetypes
PLUGINS = { "alpha", "neo-tree" }

-- Paths
HOME_PATH = vim.fn.expand("$HOME")
CONFIG_PATH = vim.fn.stdpath("config")
LAZY_PATH = vim.fn.stdpath("data") .. "/lazy"

-- Linting icons
ICON_ERROR = "E"
ICON_WARN = "W"
ICON_INFO = "I"
ICON_HINT = "H"

-- Configuration files
vim.cmd("source ~/AppData/Local/nvim/viml/utils.vim")
vim.cmd("source ~/AppData/Local/nvim/viml/autocommands.vim")
require("user.autocmds")
require("user.options")
require("user.utils")
require("user.mappings")
require("user.plugins")
