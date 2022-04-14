local colors = require("themer.modules.core.api").get_cp(SCHEME)
local lighten = require("themer.utils.colors").lighten
local darken = require("themer.utils.colors").darken

colors.bg.lighter = lighten(colors.bg.base, 0.9, "#4C4C4C")
colors.bg.darker = darken(colors.bg.base, 0.9, "#000000")

require("themer").setup({
    colorscheme = SCHEME,
    styles = {
        comment = { style = "italic" },
        ["function"] = { style = "italic" },
    },
    remaps = {
        highlights = {
            globals = {
                -- themer
                themer = {
                    ThemerNormalFloat = { bg = colors.bg.darker },
                    ThemerBorder = { fg = colors.blue },
                },
                -- base
                base = {
                    Folded = {
                        fg = colors.syntax.comment or colors.dimmed.subtle,
                        bg = lighten(colors.bg.base, 0.9, colors.syntax.comment),
                    },
                    FoldColumn = { fg = colors.blue, bg = colors.bg.base },
                    LineNr = { fg = colors.blue, bg = colors.bg.base },
                    LineNrAbove = { link = "ThemerDimmed" },
                    LineNrBelow = { link = "ThemerDimmed" },
                    MatchParen = { fg = colors.diagnostic.warn, bg = "None", style = "bold" },
                    TabLineFill = { fg = colors.bg.lighter, bg = colors.bg.lighter },
                    SpellBad = { fg = "#ee6d85", bg = "black", style = "bold" },
                    SpellCap = { fg = colors.green, bg = "black", style = "bold" },
                    SpellLocal = { fg = colors.blue, bg = "black", style = "bold" },
                    SpellRare = { fg = colors.magenta, bg = "black", style = "bold" },
                    VertSplit = { fg = colors.bg.lighter, bg = "None", style = "None" },
                    StatusLine = { link = "VertSplit", style = "None" },
                    StatusLineNC = { link = "VertSplit", style = "None" },
                    NormalFloat = { link = "ThemerNormalFloat" },
                    FloatBorder = { link = "ThemerBorder" },
                },
                plugins = {
                    virtcolumn = {
                        -- virtcolumn
                        VirtColumn = {
                            fg = darken(colors.blue, 0.5, "#000000"),
                            bg = "None",
                        },
                    },
                    indentline = {
                        -- indentline
                        IndentBlanklineChar = { fg = lighten(colors.bg.base, 0.9, "#FFFFFF") },
                    },
                    cmp = {
                        -- cmp
                        CmpItemMenu = { fg = colors.pum.fg, bg = colors.pum.bg },
                        CmpDocumentation = { fg = colors.pum.fg, bg = colors.pum.bg },
                        CmpDocumentationBorder = { bg = colors.pum.bg },
                    },
                    telescope = {
                        TelescopePromptPrefix = { fg = colors.red },
                        TelescopeNormal = { link = "ThemerNormalFloat" },
                    },
                    vimtex = {
                        -- vimtex
                        texStatement = { link = "ThemerField" },
                        texOnlyMath = { link = "ThemerPunctuation" },
                        texDefName = { link = "ThemerType" },
                        texNewCmd = { link = "ThemerOperator" },
                        texCmdName = { link = "ThemerPunctuation" },
                        texBeginEnd = { link = "ThemerInclude" },
                        texBeginEndName = { link = "ThemerPunctuation" },
                        texDocType = { link = "ThemerStruct" },
                        texDocTypeArgs = { link = "ThemerOperator" },
                        texCmd = { link = "ThemerField" },
                        texCmdClass = { link = "ThemerStruct" },
                        texCmdTitle = { link = "ThemerStruct" },
                        texCmdAuthor = { link = "ThemerStruct" },
                        texCmdPart = { link = "ThemerStruct" },
                        texCmdBib = { link = "ThemerStruct" },
                        texCmdPackage = { link = "ThemerType" },
                        texCmdNew = { link = "ThemerType" },
                        texArgNew = { link = "ThemerOperator" },
                        texPartArgTitle = { link = "ThemerConstantBuiltIn" },
                        texFileArg = { link = "ThemerConstantBuiltIn" },
                        texEnvArgName = { link = "ThemerConstantBuiltIn" },
                        texMathEnvArgName = { link = "ThemerConstantBuiltIn" },
                        texTitleArg = { link = "ThemerConstantBuiltIn" },
                        texAuthorArg = { link = "ThemerConstantBuiltIn" },
                    },
                    neotree = {
                        NeoTreeRootName = { link = "ThemerMatch" },
                        NeoTreeDirectoryName = { link = "ThemerMatch" },
                        -- NeoTreeGitUntracked = { link = "FloatBorder" },
                        NeoTreeNormal = { bg = colors.bg.darker },
                        NeoTreeNormalNC = { bg = colors.bg.darker },
                    },
                },
            },
        },
    },
})
