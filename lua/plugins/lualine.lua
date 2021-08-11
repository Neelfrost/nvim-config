local components = require("plugins.config.lualine")

require("lualine").setup({
	options = { theme = "ayu_dark", section_separators = "", component_separators = { "│", "│" } },
	sections = {
		lualine_a = { { components.Mode }, { components.Wrap }, { components.Paste } },
		lualine_b = { { components.Filename }, { components.Spell } },
		lualine_c = { { components.FileEncoding }, { components.FileFormat } },
		lualine_x = {
			{ components.LspProgress },
			{
				"branch",
				condition = function()
					return vim.fn.winwidth(0) > 70 and not components.BufIsPlugin()
				end,
			},
		},
		lualine_y = { { components.LineInfo } },
		lualine_z = { { components.TotalLines } },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = { { components.Filename } },
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
})
