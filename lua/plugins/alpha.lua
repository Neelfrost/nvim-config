-- Fix buffer movement, remove eob in dashboard
vim.cmd([[
    augroup ALPHA
        autocmd!
        autocmd FileType alpha setlocal buflisted | setlocal fillchars=eob:\ ,
    augroup END
]])

local dashboard = require("alpha.themes.dashboard")
local plugins_loaded = #vim.fn.globpath(PACKER_PATH .. "\\start", "*", 0, 1)
local plugins_waiting = #vim.fn.globpath(PACKER_PATH .. "\\opt", "*", 0, 1)

local function set_button(sc, txt, keybind, keybind_opts)
    local button = dashboard.button(sc, txt, keybind, keybind_opts)
    button.opts.hl = "DevIconJl"
    button.opts.hl_shortcut = "DevIconJl"
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
    opts = { position = "center", hl = "DevIconJl" },
}

local footer = {
    type = "text",
    val = {
        plugins_loaded + plugins_waiting .. " plugins installed",
    },
    opts = { position = "center", hl = "DevIconJl" },
}

local buttons = {
    type = "group",
    val = {
        set_button("1", "  Load Last Session", ":LoadLastSession<CR>"),
        set_button("2", "  Browse Sessions", ":lua require('plugins.config.telescope').sessions()<CR>"),
        set_button("3", "  Recent Files", ":lua require('plugins.config.telescope').frecency()<CR>"),
        set_button("4", "  Find Files", ":Telescope find_files<CR>"),
        set_button("5", "  New File", ":enew<CR>"),
        set_button("6", "  Quit", ":qa<CR>"),
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
