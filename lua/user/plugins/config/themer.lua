local colors = require("themer.modules.core.api").get_cp(SCHEME)
local lighten = require("themer.utils.colors").lighten

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
                    ThemerNormalFloat = { link = "ThemerNormal" },
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
                    TabLineFill = {
                        fg = lighten(colors.bg.base, 0.9, "#4C4C4C"),
                        bg = lighten(colors.bg.base, 0.9, "#4C4C4C"),
                    },
                    SpellBad = { fg = "#ee6d85", bg = "black", style = "bold" },
                    SpellCap = { fg = colors.green, bg = "black", style = "bold" },
                    SpellLocal = { fg = colors.blue, bg = "black", style = "bold" },
                    SpellRare = { fg = colors.magenta, bg = "black", style = "bold" },
                    NormalFloat = { bg = colors.bg.base },
                    VertSplit = {
                        fg = lighten(colors.bg.base, 0.9, "#4C4C4C"),
                        bg = lighten(colors.bg.base, 0.9, "#4C4C4C"),
                    },
                    StatusLine = { link = "VertSplit" },
                    StatusLineNC = { link = "VertSplit" },
                },
                plugins = {
                    virtcolumn = {
                        -- virtcolumn
                        VirtColumn = { link = "ThemerComment" },
                    },
                    indentline = {
                        -- indentline
                        IndentBlanklineChar = { link = "ThemerComment" },
                    },
                    cmp = {
                        -- cmp
                        CmpItemMenu = { fg = colors.pum.fg, bg = colors.pum.bg },
                        CmpDocumentation = { fg = colors.pum.fg, bg = colors.pum.bg },
                        CmpDocumentationBorder = { bg = colors.pum.bg },
                    },
                    telescope = {
                        TelescopePromptPrefix = { fg = colors.red },
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
                        NeoTreeGitUntracked = { link = "FloatBorder" },
                    },
                },
            },
        },
    },
})
