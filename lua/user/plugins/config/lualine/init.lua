local components = require("user.plugins.config.lualine.components")

require("lualine").setup({
    options = {
        globalstatus = true,
        theme = components.theme(),
        section_separators = { left = "", right = "" },
        component_separators = { left = "│", right = "│" },
    },
    sections = {
        lualine_a = {
            { components.current_mode },
        },
        lualine_b = {
            { components.file_name },
            { components.lsp },
        },
        lualine_c = {
            { components.spell },
            { components.file_encoding },
            { components.file_format },
        },
        lualine_x = {
            { components.mixed_indent },
            { components.wrap },
            { components.paste },
        },
        lualine_y = {
            { components.line_info },
            { components.total_lines },
        },
        lualine_z = {
            {
                "branch",
                icon = "",
                cond = function()
                    return not components.buffer_is_plugin()
                end,
            },
        },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = { { components.file_name } },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    extensions = {},
})