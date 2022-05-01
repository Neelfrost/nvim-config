local components = require("user.plugins.config.lualine.components")
local utils = require("user.plugins.config.lualine.utils")

require("lualine").setup({
    options = {
        globalstatus = true,
        theme = components.theme(),
        section_separators = { left = "", right = "" },
        component_separators = { left = "│", right = "│" },
    },
    sections = utils.process_sections({
        lualine_a = {
            { components.current_mode },
        },
        lualine_b = {
            {
                "branch",
                icon = "",
                cond = function()
                    return not components.buffer_is_plugin()
                end,
            },
            { components.file_name },
            {
                components.compile_status,
                padding = 0,
                color = function()
                    local scheme_colors = require("themer.modules.core.api").get_cp(SCHEME)

                    if not vim.b.vimtex then
                        return
                    end

                    if vim.b.vimtex["compiler"]["status"] == 1 then
                        return { fg = scheme_colors.blue }
                    elseif vim.b.vimtex["compiler"]["status"] == 2 then
                        return { fg = scheme_colors.green }
                    elseif vim.b.vimtex["compiler"]["status"] == 3 then
                        return { fg = scheme_colors.red }
                    else
                        return
                    end
                end,
            },
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
            { components.lsp },
            { components.line_info },
        },
        lualine_z = {
            { components.total_lines },
        },
    }),
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
