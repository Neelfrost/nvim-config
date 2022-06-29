local present, themer_api = pcall(require, "themer.modules.core.api")
if not present then
    return
end

local colors = themer_api.get_cp(SCHEME)
local utils = require("user.plugins.config.themer.utils")

local active_fg = colors.blue
local active_bg = colors.bg.base
local inactive_fg = utils.adjust_color(colors.fg, -150)
local inactive_bg = utils.adjust_color(colors.bg.base, 5)
local modified_fg = colors.red
local switch_fg = colors.green

--- Variable padding component
--- @param n number amount of padding (default: 1)
--- @return table component
local padding = setmetatable({ text = " " }, {
    __call = function(_, n)
        return { text = string.rep(" ", n) }
    end,
})

--- Poor man's superscript converter
--- @param n number number to be converted into superscript
--- @return string converted superscript number
local function superscript(n)
    local superscripts = { "⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹" }
    local str = tostring(n)
    local digits = {}
    for i = 1, #str do
        digits[i] = superscripts[1 + (str:sub(i, i) % 10)]
    end

    return table.concat(digits, "")
end

local is_picking_focus = require("cokeline.mappings").is_picking_focus
local is_picking_close = require("cokeline.mappings").is_picking_close
local buffer_ignore_types = { "terminal", "quickfix" }

require("cokeline").setup({
    show_if_buffers_are_at_least = 1,

    buffers = {
        filter_visible = function(buffer)
            return not vim.tbl_contains(buffer_ignore_types, buffer.type)
        end,
        new_buffers_position = "next",
    },

    mappings = {
        cycle_prev_next = true,
    },

    rendering = {
        max_buffer_width = 24,
    },

    sidebar = {
        filetype = "neo-tree",
        components = {
            {
                text = "  Neo-Tree",
                hl = {
                    fg = active_fg,
                    bg = active_bg,
                    style = "bold",
                },
            },
        },
    },

    default_hl = {
        fg = function(buffer)
            return buffer.is_focused and active_fg or inactive_fg
        end,
        bg = function(buffer)
            return buffer.is_focused and active_bg or inactive_bg
        end,
        style = function(buffer)
            return buffer.is_focused and "bold" or nil
        end,
    },

    components = {
        padding(2),
        {
            text = function(buffer)
                return buffer.unique_prefix
            end,
        },
        {
            text = function(buffer)
                return buffer.filename
            end,
            truncation = {
                priority = 10,
                direcion = "left",
            },
        },
        padding,
        {
            text = function(buffer)
                if is_picking_focus() or is_picking_close() then
                    return buffer.pick_letter
                end

                return superscript(buffer.index)
            end,
            fg = function()
                if is_picking_focus() then
                    return switch_fg
                elseif is_picking_close() then
                    return modified_fg
                else
                    return nil
                end
            end,
        },
        padding,
        {
            text = function(buffer)
                return buffer.is_modified and "" or ""
            end,
            delete_buffer_on_left_click = true,
            fg = function(buffer)
                return buffer.is_modified and modified_fg or nil
            end,
        },
        padding(2),
    },
})

local map = vim.keymap.set
local opts = { silent = true }

map("n", "<Tab>", "<Plug>(cokeline-focus-next)", opts)
map("n", "<S-Tab>", "<Plug>(cokeline-focus-prev)", opts)
map("n", "<M-Left>", "<Plug>(cokeline-switch-prev)", opts)
map("n", "<M-Right>", "<Plug>(cokeline-switch-next)", opts)
map("n", "<Leader>bf", "<Plug>(cokeline-pick-focus)", opts)
map("n", "<Leader>bc", "<Plug>(cokeline-pick-close)", opts)
