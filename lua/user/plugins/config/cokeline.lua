local present, themer_api = pcall(require, "themer.modules.core.api")
if not present then
    return
end

local colors = themer_api.get_cp(SCHEME)
local utils = require("user.plugins.config.themer.utils")

local active_fg = colors.blue
local active_bg = colors.bg.base
local inactive_fg = utils.adjust_color(colors.fg, -100)
local inactive_bg = utils.adjust_color(colors.bg.base, 5)
local modified_fg = colors.red
local switch_fg = colors.green

--- Variable padding component
--- @param n number Amount of padding (default: 1)
--- @return table Padding component
local padding_component = setmetatable({
    text = " ",
    truncation = { priority = 1 },
}, {
    __call = function(_, n)
        return {
            text = string.rep(" ", n),
            truncation = { priority = 1 },
        }
    end,
})

--- Poor man's superscript converter
--- @param n number Number to be converted into superscript
--- @return string Converted superscript number
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

local function is_picking_focus_or_close()
    return is_picking_focus() or is_picking_close()
end

require("cokeline").setup({
    show_if_buffers_are_at_least = 1,

    buffers = {
        filter_valid = function(buffer)
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
            return (buffer.is_focused and not (is_picking_focus_or_close())) and active_fg or inactive_fg
        end,
        bg = function(buffer)
            return (buffer.is_focused and not (is_picking_focus_or_close())) and active_bg or inactive_bg
        end,
        style = function(buffer)
            return (buffer.is_focused and not (is_picking_focus_or_close())) and "bold" or nil
        end,
    },

    components = {
        {
            text = "|",
            fg = inactive_fg,
            bg = inactive_bg,
            truncation = { priority = 1 },
        },
        padding_component(2),
        {
            text = function(buffer)
                return is_picking_focus_or_close() and buffer.pick_letter .. " " or buffer.devicon.icon
            end,
            fg = function(buffer)
                if is_picking_focus() then
                    return switch_fg
                elseif is_picking_close() then
                    return modified_fg
                elseif buffer.is_focused then
                    return buffer.devicon.color
                else
                    return inactive_fg
                end
            end,
            truncation = { priority = 1 },
        },
        {
            text = function(buffer)
                return buffer.unique_prefix
            end,
            truncation = {
                priority = 3,
                direcion = "right",
            },
        },
        {
            text = function(buffer)
                return buffer.unique_prefix ~= "" and "/" or ""
            end,
            truncation = { priority = 1 },
        },
        {
            text = function(buffer)
                return buffer.filename
            end,
            truncation = {
                priority = 2,
                direcion = "left",
            },
        },
        padding_component,
        {
            text = function(buffer)
                return superscript(buffer.index)
            end,
            truncation = { priority = 1 },
        },
        padding_component,
        {
            text = function(buffer)
                return buffer.is_modified and "" or ""
            end,
            delete_buffer_on_left_click = true,
            fg = function(buffer)
                return buffer.is_modified and modified_fg or nil
            end,
            truncation = { priority = 1 },
        },
        padding_component(2),
        {
            text = function(buffer)
                return buffer.is_last and "|" or ""
            end,
            fg = inactive_fg,
            bg = inactive_bg,
            truncation = { priority = 1 },
        },
    },
})

local map = vim.keymap.set
local opts = { silent = true }

map("n", "<Tab>", "<Plug>(cokeline-focus-next)", opts)
map("n", "<S-Tab>", "<Plug>(cokeline-focus-prev)", opts)
map("n", "<M-Left>", "<Plug>(cokeline-switch-prev)", opts)
map("n", "<M-Right>", "<Plug>(cokeline-switch-next)", opts)
map("n", "<Leader>bf", function()
    require("cokeline.mappings").pick("focus")
end, opts)
map("n", "<Leader>bc", function()
    require("cokeline.mappings").pick("close")
end, opts)
