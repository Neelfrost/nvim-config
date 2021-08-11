-- Disable imaps (using Ultisnips)
vim.g.vimtex_imaps_enabled = 0
-- Do not open pdfviwer on compile
vim.g.vimtex_view_automatic = 0
-- Disable conceal
vim.g.vimtex_syntax_conceal_default = 0
-- Disable quickfix auto open
vim.g.vimtex_quickfix_ignore_mode = 0
-- PDF viewer settings
vim.g.vimtex_view_general_viewer = "SumatraPDF"
vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
vim.g.vimtex_view_general_options_latexmk = "-reuse-instance"
vim.g.vimtex_quickfix_mode = 0
-- Latex warnings to ignore
vim.g.vimtex_quickfix_ignore_filters = {
	[[Underfull \\hbox (badness [0-9]*) in paragraph at lines]],
	[[Overfull \\hbox ([0-9]*.[0-9]*pt too wide) in paragraph at lines]],
	[[Underfull \\hbox (badness [0-9]*) in]],
	[[Overfull \\hbox ([0-9]*.[0-9]*pt too wide) in]],
	"Package hyperref Warning: Token not allowed in a PDF string",
	"Package typearea Warning: Bad type area settings!",
	"Command terminated with space",
	[[Package fancyhdr Warning: \\headheight is too small]],
	"Package caption Warning: The option",
	[[Package caption Warning: Unused \\captionsetup]],
	"Package enumitem Warning: Negative labelwidth",
	"LaTeX Font Warning: Font shape",
}
