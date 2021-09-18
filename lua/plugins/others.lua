-- Contains configs for plugins which require < 10 lines
local M = {}

function M.autopairs()
	vim.g.AutoPairsShortcutToggle = ""
	vim.api.nvim_set_keymap("i", "<C-l>", "<Esc><cmd>call AutoPairsJump()<CR>a", { noremap = true })
	-- Use defer to lazy loading
	vim.defer_fn(function()
		vim.cmd([[let g:AutoPairs = AutoPairsDefine({'<' : '>'})]])
	end, 30)
end

function M.gutentags()
	vim.g.gutentags_generate_on_new = 1
	vim.g.gutentags_generate_on_write = 1
	vim.g.gutentags_generate_on_missing = 1
	vim.g.gutentags_generate_on_empty_buffer = 0
end

function M.openurl()
	vim.g.open_url_default_mappings = 0
	vim.api.nvim_set_keymap("n", "<Leader>u", "<Plug>(open-url-browser)", {})
	vim.api.nvim_set_keymap("n", "<Leader>s", "<Plug>(open-url-search)", {})
end

function M.ultisnips()
	-- Disable snipmate plugins to avoid duplicate snippets
	vim.g.UltiSnipsEnableSnipMate = 0
	vim.g.UltiSnipsExpandTrigger = "<Tab>"
	vim.g.UltiSnipsJumpForwardTrigger = "<Tab>"
	vim.g.UltiSnipsJumpBackwardTrigger = "<S-Tab>"
end

function M.zepl()
	-- Enable the Python contrib module
	vim.cmd([[runtime zepl/contrib/python.vim]])
	vim.g.repl_config = {
		python = {
			cmd = "python",
			formatter = vim.fn["zepl#contrib#python#formatter"],
		},
	}
end

function M.treesitter()
	require("nvim-treesitter.configs").setup({
		ensure_installed = { "python", "comment", "lua", "c_sharp" },
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
	})
end

function M.ts_rainbow()
	require("nvim-treesitter.configs").setup({
		rainbow = {
			enable = true,
			extended_mode = true, -- Highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
			max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
		},
	})
end

function M.nvim_comment()
	require("nvim_comment").setup({
		comment_empty = false,
	})
end

function M.refactoring()
	require("refactoring").setup()
	local nse_opts = { noremap = true, silent = true, expr = false }
	vim.api.nvim_set_keymap(
		"v",
		"<Leader>ef",
		[[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
		nse_opts
	)
	vim.api.nvim_set_keymap(
		"v",
		"<Leader>rt",
		[[ <Esc><Cmd>lua require("plugins.config.refactoring").refactors()<CR>]],
		nse_opts
	)
end

return M