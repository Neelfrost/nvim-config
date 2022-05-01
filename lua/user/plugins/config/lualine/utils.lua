local M = {}

-- https://github.com/mvpopuk/inspired-github.vim/blob/main/config/lualine.lua
local empty = require("lualine.component"):extend()
function empty:draw(default_highlight)
    self.status = ""
    self.applied_separator = ""
    self:apply_highlights(default_highlight)
    self:apply_section_separators()
    return self.status
end

-- Put proper separators and gaps between components in sections
M.process_sections = function(sections)
    local scheme_colors = require("themer.modules.core.api").get_cp(SCHEME)
    for name, section in pairs(sections) do
        local left = name:sub(9, 10) < "x"
        for pos = 1, name ~= "lualine_z" and #section or #section - 1 do
            if name == "lualine_c" or name == "lualine_x" then
                table.insert(section, pos * 2, { empty, color = { fg = "None", bg = "None" } })
            else
                table.insert(section, pos * 2, { empty, color = { fg = "None", bg = scheme_colors.bg.base } })
            end
        end
        for id, comp in ipairs(section) do
            if type(comp) ~= "table" then
                comp = { comp }
                section[id] = comp
            end
            comp.separator = left and { right = "" } or { left = "" }
        end
    end
    return sections
end

return M
