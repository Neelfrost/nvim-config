local present, themer_api = pcall(require, "themer.modules.core.api")
if not present then
    return
end

-- Themer colors
local themer = require("user.plugins.config.themer")
local colors = themer.colors
local utils = themer.utils

local M = {}

M.vim = utils.adjust_color(colors.green, -30)
M.fg1 = colors.fg_darker
M.bg1 = colors.bg.lighter

-- Component color
M.component = { fg = M.fg1, bg = M.bg1, bold = true }

-- Surround color
M.surround = { fg = M.bg1, bg = colors.bg.base, bold = true }

-- Winbar Color
M.winbar = { fg = M.fg1, bg = M.bg1 }

return M
