local saga = require("lspsaga")

saga.init_lsp_saga({
	use_saga_diagnostic_sign = false,
	definition_preview_icon = " ﰇ ",
	border_style = "single",
	rename_prompt_prefix = "凜",
	code_action_keys = {
		quit = "<C-c>",
		exec = "<CR>",
	},
	rename_action_keys = {
		quit = "<C-c>",
		exec = "<CR>",
	},
})
