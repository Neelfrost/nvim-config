-- Author: Neel Basak
-- Github: https:/github.com/Neelfrost
-- File: init.lua

-- Paths
HOME_PATH = vim.fn.expand("$HOME")
CONFIG_PATH = vim.fn.stdpath("config")
PACKER_PATH = vim.fn.stdpath("data") .. "\\site\\pack\\packer"

-- Linting icons
ICON_ERROR = "E"
ICON_WARN = "W"
ICON_INFO = "I"
ICON_HINT = "H"

-- General config
require("options")
require("utils")
require("autocommands")
require("mappings")
require("pluginlist")
