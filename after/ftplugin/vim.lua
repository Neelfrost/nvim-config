-- Disable inserting comment leader after hitting o or O
-- Disable inserting comment leader after hitting <Enter> in insert mode
vim.opt_local.formatoptions:remove({ "o", "r" })
vim.opt_local.textwidth = 80
vim.cmd([[let b:AutoPairs = AutoPairsDefine({'<' : '>'})]])
