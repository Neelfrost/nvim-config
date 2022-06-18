local present, themer_api = pcall(require, "themer.modules.core.api")
if not present then
    return
end

local colors = themer_api.get_cp(SCHEME)
local utils = require("user.plugins.config.themer.utils")

local M = {}

M.vim = utils.adjust_color(colors.green, -30)

M.fg1 = utils.adjust_color(colors.fg, -80)
M.fg2 = utils.adjust_color(colors.orange, -40)

M.bg1 = utils.adjust_color(colors.bg.base, 16)
M.bg2 = utils.adjust_color(colors.bg.base, 5)
M.bg3 = utils.adjust_color(colors.bg.base, 2)

M.b = { fg = M.fg1, bg = M.bg2, bold = true }
M.c = { fg = M.fg2, bg = M.bg3, bold = true }

M.bi = { bg = colors.bg.base, fg = M.bg2, bold = true }
M.ci = { bg = colors.bg.base, fg = M.bg3, bold = true }

return M
