local M = {}

M.adjust_color = function(col, amt)
    local function clamp(component)
        return math.min(math.max(component, 0), 255)
    end

    local num = tonumber(col:gsub("#", ""), 16)
    local r = math.floor(num / 0x10000) + amt
    local g = (math.floor(num / 0x100) % 0x100) + amt
    local b = (num % 0x100) + amt
    return string.format("#%06X", clamp(r) * 0x10000 + clamp(g) * 0x100 + clamp(b))
end

return M
