require("indent_blankline").setup({
	filetype_exclude = {
		"vim",
		"help",
		"packer",
		"NvimTree",
		"dashboard",
		"TelescopePrompt",
		"TelescopeResults",
	},
	buftype_exclude = { "terminal" },
	char = "│",
	space_char_blankline = " ",
	show_first_indent_level = false,
	show_trailing_blankline_indent = false,
})
