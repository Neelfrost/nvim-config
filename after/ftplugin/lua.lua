-- Disable inserting comment leader after hitting o or O
-- Disable inserting comment leader after hitting <Enter> in insert mode
vim.opt_local.formatoptions:remove({ "o", "r" })
vim.opt_local.textwidth = 120
vim.cmd([[let b:AutoPairs = AutoPairsDefine({'<' : '>'})]])

local n_opts = { noremap = true }
-- Run lua script
-- With terminal
vim.api.nvim_buf_set_keymap(0, "n", "<Leader>t", "<cmd>w!<CR><cmd>AsyncRun -mode=term -pos=external lua %<CR>", n_opts)
-- Without terminal
vim.api.nvim_buf_set_keymap(0, "n", "<Leader>r", "<cmd>w!<CR><cmd>AsyncRun lua %<CR>", n_opts)

-- Run love2d
-- With terminal
vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<Leader>lt",
	"<cmd>w!<CR><cmd>AsyncRun -mode=term -pos=external lovec .<CR>",
	n_opts
)
-- Without terminal
vim.api.nvim_buf_set_keymap(0, "n", "<Leader>lr", "<cmd>w!<CR><cmd>AsyncRun love .<CR>", n_opts)
