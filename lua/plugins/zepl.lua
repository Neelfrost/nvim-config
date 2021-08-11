-- Enable the Python contrib module
vim.cmd([[runtime zepl/contrib/python.vim]])

vim.g.repl_config = {
	python = {
		cmd = "python",
		formatter = vim.fn["zepl#contrib#python#formatter"],
	},
}
