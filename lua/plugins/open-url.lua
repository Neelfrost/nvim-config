vim.g.open_url_default_mappings = 0

vim.api.nvim_set_keymap("n", "<Leader>u", "<Plug>(open-url-browser)", {})
vim.api.nvim_set_keymap("n", "<Leader>s", "<Plug>(open-url-search)", {})
