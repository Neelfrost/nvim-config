local get_hex = require("cokeline.utils").get_hex

require("cokeline").setup({
	hide_when_one_buffer = false,
	cycle_prev_next_mappings = true,

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

	components = {
		{
			text = "| ",
			hl = {
				fg = get_hex("folded", "fg"),
				style = "bold",
			},
		},
		{
			text = function(buffer)
				return buffer.index .. ": "
			end,
			hl = {
				style = "bold",
			},
		},
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
				return buffer.filename .. " "
			end,
			hl = {
				style = "bold",
			},
		},
		{
			text = function(buffer)
				return buffer.is_modified and " " or " "
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
