-- Fix buffer movement, remove eob in dashboard
vim.cmd([[
    augroup ALPHA
        autocmd!
        autocmd FileType alpha setlocal buflisted | setlocal fillchars=eob:\ ,
    augroup END
]])

local dashboard = require("alpha.themes.dashboard")
local plugins_loaded = vim.fn.len(vim.fn.globpath(PACKER_PATH .. "\\start", "*", 0, 1))
local plugins_waiting = vim.fn.len(vim.fn.globpath(PACKER_PATH .. "\\opt", "*", 0, 1))

local function set_button(sc, txt, keybind, keybind_opts)
    local button = dashboard.button(sc, txt, keybind, keybind_opts)
    button.opts.hl = "Title"
    button.opts.hl_shortcut = "Title"
    return button
end

local header = {
    type = "text",
    val = {
        "                                                   ",
        "                                                   ",
        "                                                   ",
        "                                                   ",
        " ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓",
        " ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒",
        "▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░",
        "▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██",
        "▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒",
        "░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░",
        "░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░",
        "   ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░",
        "         ░    ░  ░    ░ ░        ░   ░         ░",
        "                                ░",
    },
    opts = { position = "center", hl = "TelescopeBorder" },
}

local footer = {
    type = "text",
    val = {
        " " .. "Plugins: " .. plugins_loaded .. "(L), " .. plugins_waiting .. "(LL) ",
    },
    opts = { position = "center", hl = "TelescopeBorder" },
}

local buttons = {
    type = "group",
    val = {
        set_button("1", "  Recent Files", ":lua require('plugins.config.telescope').frecency()<CR>"),
        set_button("2", "  Find Files", ":Telescope find_files<CR>"),
        set_button("3", "  New File", ":enew<CR>"),
        set_button("4", "  Neovim Config", ":lua require('plugins.config.telescope').dir_nvim()<CR>"),
        set_button("5", "  Quit", ":qa<CR>"),
    },
    opts = {
        spacing = 1,
    },
}

local opts = {
    layout = {
        { type = "padding", val = 2 },
        header,
        { type = "padding", val = 2 },
        buttons,
        { type = "padding", val = 2 },
        footer,
    },
    opts = {
        margin = 5,
    },
}

-- Send config to alpha
require("alpha").setup(opts)
