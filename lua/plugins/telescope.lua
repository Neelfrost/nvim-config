local actions = require("telescope.actions")
local custom_config = require("plugins.config.telescope")

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
		layout_config = {
			horizontal = {
				mirror = false,
			},
			vertical = {
				mirror = false,
			},
		},
		winblend = 0,
		use_less = true,
		entry_prefix = "  ",
		prompt_prefix = "❯ ",
		color_devicons = true,
		selection_caret = "❯ ",
		initial_mode = "insert",
		selection_strategy = "reset",
		path_display = { "absolute" },
		layout_strategy = "horizontal",
		sorting_strategy = "descending",
		file_ignore_patterns = { ".git", "tags" },
		set_env = { ["COLORTERM"] = "truecolor" },
		file_sorter = require("telescope.sorters").get_fuzzy_file,
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
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
		find_files = custom_config.dropdown(),
		oldfiles = custom_config.dropdown({ prompt_title = "Recent Files" }),
		git_files = custom_config.dropdown(),
	},
	extensions = {
		frecency = {
			show_scores = false,
			show_unindexed = false,
			ignore_patterns = { "*.git/*" },
		},
	},
})

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<Leader>tr", "<cmd>lua require('plugins.config.telescope').frecency()<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>tf", "<cmd>lua require('telescope.builtin').find_files()<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>tp", "<cmd>lua require('plugins.config.telescope').dir_python()<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>tn", "<cmd>lua require('plugins.config.telescope').dir_nvim()<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>tl", "<cmd>lua require('plugins.config.telescope').dir_latex()<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>ts", "<cmd>lua require('plugins.config.telescope').list_sessions()<CR>", opts)
vim.api.nvim_set_keymap("n", "<F5>", "<cmd>lua require('plugins.config.telescope').reload_modules()<CR>", opts)
