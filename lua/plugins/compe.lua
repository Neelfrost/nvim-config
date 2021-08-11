require("compe").setup({
	enabled = true,
	autocomplete = true,
	debug = false,
	min_length = 2,
	preselect = "enable",
	throttle_time = 80,
	source_timeout = 200,
	resolve_timeout = 800,
	incomplete_delay = 400,
	max_abbr_width = 100,
	max_kind_width = 100,
	max_menu_width = 100,
	documentation = {
		true,
		border = { "", "", "", " ", "", "", "", " " },
		winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
	},
	source = {
		omni = {
			kind = "  ",
			filetypes = { "tex" },
		},
		path = { kind = "  " },
		buffer = { kind = " ﬘ " },
		nvim_lsp = { kind = "  " },
		nvim_lua = { kind = "  " },
		ultisnips = { kind = "  " },
	},
})

local nse_opts = { noremap = true, silent = true, expr = true }
local ne_opts = { noremap = true, expr = true }
vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()", nse_opts)
vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", nse_opts)
vim.api.nvim_set_keymap("i", "<C-e>", "compe#close('<C-e>')", nse_opts)
vim.api.nvim_set_keymap("i", "<C-j>", "pumvisible() ? '<C-n>' : '<C-j>'", ne_opts)
vim.api.nvim_set_keymap("i", "<C-k>", "pumvisible() ? '<C-p>' : '<C-k>'", ne_opts)
