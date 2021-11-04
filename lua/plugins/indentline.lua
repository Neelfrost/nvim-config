local filetypes = {
    "vim",
    "help",
    "TelescopePrompt",
    "TelescopeResults",
}
filetypes = vim.list_extend(filetypes, PLUGINS)

require("indent_blankline").setup({
    char = "│",
    space_char_blankline = " ",
    show_first_indent_level = false,
    show_trailing_blankline_indent = false,
    filetype_exclude = filetypes,
    buftype_exclude = {
        "terminal",
    },
})
