vim.g.bufferline = {
	-- Disable animations
	animation = false,
	-- Show tabs
	tabpages = true,
	-- Show only number
	icons = "numbers",
	-- Buffer modified icon
	icon_close_tab_modified = "+",
	-- Unnamed buffers
	no_name_title = "[No Name]",
}

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<Tab>", "<cmd>BufferNext<CR>", opts)
vim.api.nvim_set_keymap("n", "<S-Tab>", "<cmd>BufferPrevious<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>w", "<cmd>bd!<CR>", opts)
