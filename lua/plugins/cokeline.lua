local get_hex = require("cokeline.utils").get_hex

local buffer_ignore_types = { "terminal", "quickfix" }

local function space(n)
    return { text = string.rep(" ", n) }
end

require("cokeline").setup({
    show_if_buffers_are_at_least = 1,

    buffers = {
        filter_valid = function(buffer)
            return not vim.tbl_contains(buffer_ignore_types, buffer.type)
        end,
        new_buffers_position = "last",
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
                        fg = get_hex("DevIconC", "fg"),
                        bg = get_hex("Normal", "bg"),
                        style = "bold",
                    },
                },
            },
        },
    },

    default_hl = {
        focused = {
            fg = get_hex("DevIconC", "fg"),
            bg = get_hex("Normal", "bg"),
        },
        unfocused = {
            fg = get_hex("DevIconSh", "fg"),
            bg = get_hex("TabLineFill", "bg"),
        },
    },

    components = {
        space(2),
        {
            text = function(buffer)
                return buffer.index .. ":"
            end,
            hl = {
                style = "bold",
            },
        },
        space(1),
        {
            text = function(buffer)
                return buffer.unique_prefix
            end,
            hl = {
                style = "bold",
            },
        },
        {
            text = function(buffer)
                return buffer.filename
            end,
            hl = {
                style = "bold",
            },
            truncation = {
                priority = 10,
                direcion = "left",
            },
        },
        space(1),
        {
            text = function(buffer)
                return buffer.is_modified and "" or ""
            end,
            delete_buffer_on_left_click = true,
            hl = {
                fg = function(buffer)
                    if buffer.is_modified then
                        return get_hex("DevIconHtm", "fg")
                    end
                end,
                style = "bold",
            },
        },
        space(2),
    },
})

local opts = { silent = true }
vim.api.nvim_set_keymap("n", "<Tab>", "<Plug>(cokeline-focus-next)", opts)
vim.api.nvim_set_keymap("n", "<S-Tab>", "<Plug>(cokeline-focus-prev)", opts)
vim.api.nvim_set_keymap("n", "<M-Left>", "<Plug>(cokeline-switch-prev)", opts)
vim.api.nvim_set_keymap("n", "<M-Right>", "<Plug>(cokeline-switch-next)", opts)
