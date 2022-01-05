-- Fix buffer movement, remove eob in dashboard
vim.cmd([[
    augroup ALPHA
        autocmd!
        autocmd FileType alpha setlocal buflisted | setlocal fillchars=eob:\ ,
    augroup END
]])

-- Alpha theme
local dashboard = require("alpha.themes.dashboard")

-- Plugin count
local plugins_loaded = #vim.fn.globpath(PACKER_PATH .. "\\start", "*", 0, 1)
local plugins_waiting = #vim.fn.globpath(PACKER_PATH .. "\\opt", "*", 0, 1)

-- Common highlight
local highlight = vim.g.colors_name == "kanagawa" and "TelescopePreviewDate" or "TelescopeBorder"

local function set_button(sc, txt, keybind, keybind_opts)
    local button = dashboard.button(sc, txt, keybind, keybind_opts)
    button.opts.hl = highlight
    button.opts.hl_shortcut = highlight
    return button
end

local header = {
    type = "text",
    val = {
        "              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀                ",
        "              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀                ",
        " ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀                ",
        "              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀                ",
    },
    opts = { position = "center", hl = highlight },
}

local footer = {
    type = "text",
    val = {
        plugins_loaded + plugins_waiting .. " plugins installed",
    },
    opts = { position = "center", hl = highlight },
}

local buttons = {
    type = "group",
    val = {
        set_button("1", "  Load Last Session", "<cmd>LoadLastSession<CR>"),
        set_button("2", "  Browse Sessions", "<cmd>lua require('plugins.config.telescope').sessions()<CR>"),
        set_button("3", "  Recent Files", "<cmd>lua require('plugins.config.telescope').frecency()<CR>"),
        set_button("4", "  Find Files", "<cmd>Telescope find_files<CR>"),
        set_button("5", "  New File", "<cmd>enew<CR>"),
        set_button("u", "  Update", "<cmd>PackerSync<CR>"),
        set_button("q", "  Quit", "<cmd>qa<CR>"),
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
