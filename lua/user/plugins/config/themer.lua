local colors = require("themer.modules.core.api").get_cp(SCHEME)
local lighten = require("themer.utils.colors").lighten

require("themer").setup({
    colorscheme = SCHEME,
    styles = {
        comment = { style = "italic" },
        ["function"] = { style = "italic" },
    },
    remaps = {
        palette = {
            kanagawa = {
                bg = {
                    base = "#14171c",
                    alt = "#2a2a37",
                },
                border = colors.blue,
            },
            javacafe = {
                border = colors.blue,
            },
        },
        highlights = {
            kanagawa = {
                base = {
                    Folded = { fg = "#938aa9", bg = "#2a2a37" },
                    FoldColumn = { fg = colors.blue, bg = "#14171c" },
                },
            },
            globals = {
                base = {
                    Folded = { fg = lighten(colors.fg, 0.5, colors.blue), bg = colors.bg.alt },
                    FoldColumn = { fg = colors.blue, bg = colors.bg.base },
                    TabLineFill = {
                        fg = lighten(colors.bg.base, 0.9, "#4C4C4C"),
                        bg = lighten(colors.bg.base, 0.9, "#4C4C4C"),
                    },
                    CmpDocumentation = { fg = colors.pum.fg, bg = colors.pum.bg },
                    CmpDocumentationBorder = { fg = colors.pum.fg, bg = colors.pum.bg },
                    CmpItemMenu = { fg = colors.pum.fg, bg = colors.pum.bg },
                },
            },
        },
    },
})
