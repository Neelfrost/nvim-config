-- Contains configs for plugins which require < 10 lines
local M = {}

function M.autopairs()
	-- jiangmiao/auto-pairs
	vim.g.AutoPairsShortcutToggle = ""
	vim.api.nvim_set_keymap("i", "<C-l>", "<cmd>call AutoPairsJump()<CR>", { noremap = true })
end

function M.gutentags()
	vim.g.gutentags_generate_on_new = 1
	vim.g.gutentags_generate_on_write = 1
	vim.g.gutentags_generate_on_missing = 1
	vim.g.gutentags_generate_on_empty_buffer = 0
end

function M.indentline()
	vim.g.indent_blankline_filetype_exclude = {
		"vim",
		"help",
		"packer",
		"NvimTree",
		"dashboard",
	}
	vim.g.indent_blankline_char = "▏"
	vim.g.indent_blankline_show_first_indent_level = false
	vim.g.indent_blankline_show_trailing_blankline_indent = false
end

function M.openurl()
	vim.g.open_url_default_mappings = 0
	vim.api.nvim_set_keymap("n", "<Leader>u", "<Plug>(open-url-browser)", {})
	vim.api.nvim_set_keymap("n", "<Leader>s", "<Plug>(open-url-search)", {})
end

function M.terminalhelp()
	vim.g.terminal_height = 15
	vim.g.terminal_list = 0
end

function M.ultisnips()
	-- Disable snipmate plugins to avoid duplicate snippets
	vim.g.UltiSnipsEnableSnipMate = 0
	-- Mappings
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

return M
