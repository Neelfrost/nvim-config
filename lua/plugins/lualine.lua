local components = require("plugins.config.lualine")

require("lualine").setup({
	options = {
		theme = components.theme_transparent(),
		section_separators = { left = "", right = "" },
		component_separators = { left = "│", right = "│" },
	},
	sections = {
		lualine_a = { { components.current_mode }, { components.wrap }, { components.paste } },
		lualine_b = { { components.file_name }, { components.lsp_status } },
		lualine_c = { { components.spell }, { components.file_encoding }, { components.file_format } },
		lualine_x = {},
		lualine_y = {
			{
				"branch",
				icon = "",
				cond = function()
					return not components.buffer_is_plugin()
				end,
			},
			{ components.line_info },
		},
		lualine_z = { { components.total_lines } },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = { { components.file_name } },
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
})
