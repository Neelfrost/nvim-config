vim.opt_local.textwidth = 120

local n_opts = { noremap = true }
-- Run python script
-- With terminal
vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<Leader>t",
	"<cmd>w!<CR><cmd>AsyncRun -mode=term -pos=external python %<CR>",
	n_opts
)
-- Without terminal
vim.api.nvim_buf_set_keymap(0, "n", "<Leader>r", "<cmd>w!<CR><cmd>AsyncRun python %<CR>", n_opts)

-- Organize imports on Ctrl-F
vim.api.nvim_buf_set_keymap(0, "n", "<C-f>", "<cmd>PyrightOrganizeImports<CR>", n_opts)
