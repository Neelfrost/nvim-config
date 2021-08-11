require("hop").setup({})

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "s", "<cmd>HopChar2<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>f", "<cmd>HopChar1<CR>", opts)
vim.api.nvim_set_keymap(
	"v",
	"f",
	"<cmd>lua require('hop').hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR })<CR>",
	{}
)
vim.api.nvim_set_keymap(
	"o",
	"f",
	"<cmd>lua require('hop').hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR })<CR>",
	{}
)
