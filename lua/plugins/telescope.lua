local actions = require("telescope.actions")

require("telescope").setup({
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},
		prompt_prefix = "❯ ",
		selection_caret = "❯ ",
		entry_prefix = "  ",
		initial_mode = "insert",
		selection_strategy = "reset",
		sorting_strategy = "descending",
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				mirror = false,
			},
			vertical = {
				mirror = false,
			},
		},
		file_sorter = require("telescope.sorters").get_fuzzy_file,
		file_ignore_patterns = { ".git", "tags" },
		generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
		winblend = 0,
		border = {},
		borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
		color_devicons = true,
		use_less = true,
		path_display = { "absolute" },
		set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
		mappings = {
			i = {
				["<C-n>"] = false,
				["<C-p>"] = false,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
			n = {
				["<C-n>"] = false,
				["<C-p>"] = false,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
		},
	},
	pickers = {
		find_files = {
			theme = "dropdown",
			previewer = false,
		},
		oldfiles = {
			prompt_title = "Recent Files",
			theme = "dropdown",
			previewer = false,
		},
	},
})

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<Leader>tr", "<cmd>lua require('telescope.builtin').oldfiles()<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>tf", "<cmd>lua require('telescope.builtin').find_files()<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>tp", "<cmd>lua require('plugins.config.telescope').dir_python()<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>tn", "<cmd>lua require('plugins.config.telescope').dir_nvim()<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>tl", "<cmd>lua require('plugins.config.telescope').dir_latex()<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>ts", "<cmd>lua require('plugins.config.telescope').sessions()<CR>", opts)
vim.api.nvim_set_keymap("n", "<F5>", "<cmd>lua require('plugins.config.telescope').reload()<CR>", opts)
