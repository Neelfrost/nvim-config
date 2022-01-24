local get_hex = require("cokeline.utils").get_hex
local is_picking_focus = require("cokeline.mappings").is_picking_focus
local is_picking_close = require("cokeline.mappings").is_picking_close

local buffer_ignore_types = { "terminal", "quickfix" }

--- Create a padding component
--- @param n string amount of padding (default 1)
--- @return table component
local function padding(n)
    n = n or 1
    return { text = string.rep(" ", n) }
end

local colors = require("themer.modules.core.api").get_cp(SCHEME)
local active_fg = colors.blue
local active_bg = get_hex("Normal", "bg")
local inactive_fg = get_hex("DevIconSh", "fg")
local inactive_bg = get_hex("TabLineFill", "bg")
local modified_fg = colors.red
local switch_fg = colors.green

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
        left_sidebar = {
            filetype = "NvimTree",
            components = {
                {
                    text = "  NvimTree",
                    hl = {
                        fg = active_fg,
                        bg = active_bg,
                        style = "bold",
                    },
                },
            },
        },
    },

    default_hl = {
        focused = {
            fg = active_fg,
            bg = active_bg,
            style = "bold",
        },
        unfocused = {
            fg = inactive_fg,
            bg = inactive_bg,
            style = "bold",
        },
    },

    components = {
        padding(2),
        {
            text = function(buffer)
                return (is_picking_focus() or is_picking_close()) and (buffer.pick_letter .. ":")
                    or (buffer.index .. ":")
            end,
            hl = {
                fg = function()
                    if is_picking_close() then
                        return modified_fg
                    elseif is_picking_focus() then
                        return switch_fg
                    end
                end,
            },
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
            hl = {
                fg = function(buffer)
                    if buffer.is_modified then
                        return modified_fg
                    end
                end,
            },
        },
        padding(2),
    },
})

local opts = { silent = true }
vim.api.nvim_set_keymap("n", "<Tab>", "<Plug>(cokeline-focus-next)", opts)
vim.api.nvim_set_keymap("n", "<S-Tab>", "<Plug>(cokeline-focus-prev)", opts)
vim.api.nvim_set_keymap("n", "<M-Left>", "<Plug>(cokeline-switch-prev)", opts)
vim.api.nvim_set_keymap("n", "<M-Right>", "<Plug>(cokeline-switch-next)", opts)
vim.api.nvim_set_keymap("n", "<Leader>bf", "<Plug>(cokeline-pick-focus)", opts)
vim.api.nvim_set_keymap("n", "<Leader>bc", "<Plug>(cokeline-pick-close)", opts)
