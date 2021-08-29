-- Fix buffer movement, remove eob in dashboard
vim.cmd([[autocmd FileType dashboard :set buflisted | :setlocal scrolloff=0 | :setlocal fillchars=eob:\ ,]])

-- Plugin count
local plugins_count = vim.fn.len(vim.fn.globpath(PACKER_PATH, "*", 0, 1))

vim.g.dashboard_default_executive = "telescope"
vim.g.dashboard_session_directory = vim.fn.stdpath("data") .. "\\session"

vim.g.dashboard_custom_section = {
	a = { description = { "  Recent File               1" }, command = "Telescope oldfiles" },
	b = { description = { "  Find File                 2" }, command = "Telescope find_files" },
	c = { description = { "  New File                  3" }, command = "DashboardNewFile" },
	d = { description = { "  Load Last Session         4" }, command = "SessionLoad" },
	e = {
		description = { "  List Sessions             5" },
		command = "lua require('plugins.config.telescope').sessions()",
	},
}

vim.g.dashboard_custom_footer = {
	plugins_count .. " plugins loaded",
}

vim.g.dashboard_custom_header = {
	"              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀                ",
	"              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀                ",
	"              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀                ",
	"              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀                ",
	"              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀                ",
	" ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
	" ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
	" ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
	" ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
	" ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
	" ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
}

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<Leader>n", "<cmd>Dashboard<CR>", opts)
