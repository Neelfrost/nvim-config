local get_hex = require("cokeline.utils").get_hex

local space = {
    text = " ",
}

require("cokeline").setup({
    show_if_buffers_are_at_least = 1,
    cycle_prev_next_mappings = true,

    buffers = {
        filter = function(buffer)
            return buffer.type ~= "terminal"
        end,
    },

    default_hl = {
        focused = {
            fg = get_hex("TelescopeBorder", "fg"),
            bg = get_hex("ColorColumn", "bg"),
        },
        unfocused = {
            fg = get_hex("folded", "fg"),
            bg = get_hex("ColorColumn", "bg"),
        },
    },

    rendering = {
        max_line_width = 24,
    },

    components = {
        {
            text = "|",
            hl = {
                fg = get_hex("folded", "fg"),
                style = "bold",
            },
        },
        space,
        {
            text = function(buffer)
                return buffer.index .. ":"
            end,
            hl = {
                style = "bold",
            },
        },
        space,
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
        space,
        {
            text = function(buffer)
                return buffer.is_modified and "" or ""
            end,
            delete_buffer_on_left_click = true,
            hl = {
                fg = function(buffer)
                    if buffer.is_modified then
                        return get_hex("SpellBad", "fg")
                    end
                end,
                style = "bold",
            },
        },
        space,
        {
            text = function(buffer)
                local no_of_buffers = #vim.fn.getbufinfo({ buflisted = 1 })
                return buffer.index == no_of_buffers and "|" or ""
            end,
            hl = {
                fg = get_hex("folded", "fg"),
                style = "bold",
            },
        },
    },
})

local opts = { silent = true }
vim.api.nvim_set_keymap("n", "<Tab>", "<Plug>(cokeline-focus-next)", opts)
vim.api.nvim_set_keymap("n", "<S-Tab>", "<Plug>(cokeline-focus-prev)", opts)
vim.api.nvim_set_keymap("n", "<M-Left>", "<Plug>(cokeline-switch-prev)", opts)
vim.api.nvim_set_keymap("n", "<M-Right>", "<Plug>(cokeline-switch-next)", opts)
