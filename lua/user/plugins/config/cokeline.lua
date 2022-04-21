local get_hex = require("cokeline.utils").get_hex
local is_picking_focus = require("cokeline.mappings").is_picking_focus
local is_picking_close = require("cokeline.mappings").is_picking_close

local buffer_ignore_types = { "terminal", "quickfix" }

local colors = require("themer.modules.core.api").get_cp(SCHEME)
local active_fg = colors.blue
local active_bg = get_hex("Normal", "bg")
local inactive_fg = get_hex("DevIconSh", "fg")
local inactive_bg = get_hex("TabLineFill", "bg")
local modified_fg = colors.red
local switch_fg = colors.green

--- Create a padding component
--- @param n string amount of padding (default 1)
--- @return table component
local function padding(n)
    return { text = string.rep(" ", n or 1) }
end

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
        style = "bold",
    },

    components = {
        padding(2),
        {
            text = function(buffer)
                return (is_picking_focus() or is_picking_close()) and (buffer.pick_letter .. ":")
                    or (buffer.index .. ":")
            end,
            fg = function()
                return is_picking_close() and modified_fg or (is_picking_focus() and switch_fg or nil)
            end,
        },
        padding(),
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
        padding(),
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
