M = {}

function M.setup()
	vim.g.indent_blankline_filetype_exclude = {
		"vim",
		"help",
		"packer",
		"NvimTree",
		"dashboard",
		"TelescopePrompt",
		"TelescopeResults",
	}
	vim.g.indent_blankline_buftype_exclude = {
		"terminal",
	}
end

function M.config()
	require("indent_blankline").setup({
		char = "│",
		space_char_blankline = " ",
		show_first_indent_level = false,
		show_trailing_blankline_indent = false,
	})
end

return M
