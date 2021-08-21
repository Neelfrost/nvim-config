-- local npairs = require("nvim-autopairs")
-- local rule = require("nvim-autopairs.rule")
-- local cond = require("nvim-autopairs.conds")

-- npairs.setup({
-- 	disable_filetype = { "TelescopePrompt" },
-- 	ignored_next_char = "[%%]",
-- 	enable_moveright = true,
-- 	-- add bracket pairs after quote
-- 	enable_afterquote = false,
-- 	-- check bracket in same line
-- 	enable_check_bracket_line = true,
-- 	-- dont ignore
-- 	check_ts = false,
-- 	fast_wrap = {
-- 		map = "<M-e>",
-- 		chars = { "{", "[", "(", '"', "'" },
-- 		pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
-- 		end_key = "$",
-- 		keys = "qwertyuiopzxcvbnmasdfghjkl",
-- 		check_comma = true,
-- 		hightlight = "Search",
-- 	},
-- })

-- npairs.add_rules({
-- 	rule("$", "$", { "tex" }):with_move(cond.none()):with_cr(cond.none()),
-- 	rule("<", ">", { "tex", "lua", "vim" }):with_cr(cond.none()),
-- })

-- jiangmiao/auto-pairs
vim.g.AutoPairsShortcutJump = "<C-l>"
