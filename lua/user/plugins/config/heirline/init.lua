local c = require("user.plugins.config.heirline.components")
local conditions = require("heirline.conditions")

local normal_statusline = {
    c.vim_mode,
    c.git_info,
    c.file_block,
    c.search_results,
    c.visual_multi,
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

local statusline = {
    fallthrough = false,
    terminal_statusline,
    normal_statusline,
}

local winbar = {
    c.winbar,
}

require("heirline").setup({ statusline = statusline, winbar = winbar })
