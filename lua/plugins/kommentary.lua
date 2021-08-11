local kommentary = require("kommentary.config")

kommentary.configure_language(
	"default",
	{ prefer_single_line_comments = true, use_consistent_indentation = true, ignore_whitespace = true }
)

local opts = { silent = true }
vim.api.nvim_set_keymap("n", "<C-/>", "<Plug>kommentary_line_default", opts)
vim.api.nvim_set_keymap("i", "<C-/>", "<Esc><Plug>kommentary_line_default", opts)
vim.api.nvim_set_keymap("x", "<C-/>", "<Plug>kommentary_visual_default", opts)
