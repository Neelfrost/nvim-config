vim.opt_local.textwidth = 120

-- Format on save
vim.cmd([[
    augroup PYTHON_FORMAT
        autocmd!
        autocmd BufWritePre *.py silent! execute ':Black'
    augroup END
]])

-- Black config
vim.g.black_linelength = 120

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

-- Format on Ctrl-F
vim.api.nvim_buf_set_keymap(0, "n", "<C-f>", "", n_opts)
vim.api.nvim_buf_set_keymap(0, "n", "<C-f>", "<cmd>PyrightOrganizeImports<CR><cmd>Black<CR>", n_opts)
