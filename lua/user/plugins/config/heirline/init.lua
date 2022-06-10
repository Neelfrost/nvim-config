local c = require("user.plugins.config.heirline.components")
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local normal_statusline = {
    c.vim_mode,
    c.git_info,
    c.file_block,
    c.spellcheck,
    c.file_format,
    c.file_encoding,
    c.align,
    c.mixed_indents,
    c.wrap,
    c.paste,
    c.lsp_info,
    c.line_info,
    c.total_lines,
}

local terminal_statusline = {
    condition = function()
        return conditions.buffer_matches({ buftype = { "terminal" } })
    end,

    {
        c.vim_mode,
        c.align,
        c.terminal_name,
    },
}

require("heirline").setup({
    init = utils.pick_child_on_condition,
    terminal_statusline,
    normal_statusline,
})
