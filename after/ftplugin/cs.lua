local n_opts = { noremap = true }
-- Run C# console app
-- With terminal
vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<Leader>t",
	"<cmd>w!<CR><cmd>AsyncRun -mode=term -pos=external dotnet run<CR>",
	n_opts
)
