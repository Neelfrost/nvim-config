local n_opts = { noremap = true }
local ne_opts = { noremap = true, expr = true }
local ns_opts = { noremap = true, silent = true }
local nse_opts = { noremap = true, silent = true, expr = true }

-- Open windows terminal terminal at cwd
vim.api.nvim_set_keymap(
	"n",
	"<Leader><Leader>t",
	"<cmd>lua launch_ext_prog('wt.exe -d', string.format('\"%s\"', vim.fn.expand('%:p:h')))<CR>",
	ns_opts
)

-- Open explorer at cwd
vim.api.nvim_set_keymap(
	"n",
	"<Leader><Leader>e",
	"<cmd>lua launch_ext_prog('explorer.exe', vim.fn.expand('%:p:h'))<CR>",
	ns_opts
)

-- Open current file in vscode
vim.api.nvim_set_keymap("n", "<Leader><Leader>c", "<cmd>lua launch_ext_prog('code', '%')<CR>", ns_opts)

-- Replace word under cursor
vim.api.nvim_set_keymap("n", "<F2>", [[:%s/\<<C-r><C-w>\>/]], n_opts)
vim.api.nvim_set_keymap("v", "<F2>", [[y:%s/\V<C-r>"/]], n_opts)

-- Save file
vim.api.nvim_set_keymap("n", "<C-s>", "<cmd>update!<CR>", ns_opts)
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc><cmd>update!<CR>", ns_opts)

-- Toggle quickfix
vim.api.nvim_set_keymap("n", "<Leader>q", "<cmd>QFix<CR>", ns_opts)

-- Format entire document
vim.api.nvim_set_keymap("n", "<C-f>", "gg=G<C-o>zz<Esc>", ns_opts)

-- Toggle spell
vim.api.nvim_set_keymap("n", "<F1>", "<cmd>setlocal spell!<CR>", ns_opts)

-- Remove highlight
vim.api.nvim_set_keymap("n", "<Leader>h", "<cmd>nohl<CR>", ns_opts)

-- Map $ to g_
vim.api.nvim_set_keymap("n", "$", "g_", n_opts)
vim.api.nvim_set_keymap("v", "$", "g_", n_opts)

-- Yank till line end
vim.api.nvim_set_keymap("n", "Y", '"+yg_', n_opts)

-- Always yank to clipboard
vim.api.nvim_set_keymap("n", "y", '"+y', n_opts)
vim.api.nvim_set_keymap("v", "y", '"+y', n_opts)

-- Paste from system clipboard in insert/select mode
vim.api.nvim_set_keymap("i", "<C-v>", "<C-R>+", n_opts)
vim.api.nvim_set_keymap("s", "<C-v>", "<BS>i<C-R>+<Esc>", n_opts)

-- Toggle paste mode and paste from system clipboard
vim.api.nvim_set_keymap("n", "<Leader>v", '<F12>"+P<F12>', n_opts)
vim.api.nvim_set_keymap("i", "<Leader>v", '<ESC><F12>"+P<F12>i', n_opts)

-- Move to line end
vim.api.nvim_set_keymap("i", "<C-a>", "<Esc>g_a", n_opts)

-- Display line movements
vim.api.nvim_set_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", ne_opts)
vim.api.nvim_set_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", ne_opts)
-- vim.api.nvim_set_keymap("v", "j", "v:count == 0 ? 'gj' : 'j'", ne_opts)
-- vim.api.nvim_set_keymap("v", "k", "v:count == 0 ? 'gk' : 'k'", ne_opts)

-- Fix accidental line joining during visual block selection
vim.api.nvim_set_keymap("v", "J", "j", n_opts)
vim.api.nvim_set_keymap("v", "K", "k", n_opts)

-- Correct previous bad word in insert mode
vim.api.nvim_set_keymap("i", "<C-z>", "<C-g>u<Esc>[s1z=`]a<C-g>u", n_opts)
-- Correct word under cursor
vim.api.nvim_set_keymap("n", "<C-z>", "1z=<Esc>", n_opts)

-- Delete previous word
vim.api.nvim_set_keymap("i", "<C-BS>", "<C-w>", n_opts)
-- Delete next word
vim.api.nvim_set_keymap("i", "<C-Del>", "<C-o>dW", n_opts)

-- Indenting
vim.api.nvim_set_keymap("n", "<M-]>", ">>", n_opts)
vim.api.nvim_set_keymap("n", "<M-[>", "<<", n_opts)

-- Continuous visual shifting https://superuser.com/q/310417/736190
vim.api.nvim_set_keymap("x", "<M-]>", ">gv", n_opts)
vim.api.nvim_set_keymap("x", "<M-[>", "<gv", n_opts)

-- Window switching
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", n_opts)
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", n_opts)
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", n_opts)
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", n_opts)

-- Disable word search on shift mouse
vim.api.nvim_set_keymap("", "<S-LeftMouse>", "<nop>", {})
vim.api.nvim_set_keymap("", "<S-LeftDrag>", "<nop>", {})

-- Command mode movement
vim.api.nvim_set_keymap("c", "<C-j>", "<C-n>", n_opts)
vim.api.nvim_set_keymap("c", "<C-k>", "<C-p>", n_opts)

-- Duplicate line
vim.api.nvim_set_keymap("n", "<M-d>", "<cmd>t.<CR>", n_opts)
vim.api.nvim_set_keymap("i", "<M-d>", "<Esc><cmd>t.<CR>gi", n_opts)

-- Move line / block
vim.api.nvim_set_keymap("n", "<A-j>", ":m .+1<CR>==", n_opts)
vim.api.nvim_set_keymap("n", "<A-k>", ":m .-2<CR>==", n_opts)
vim.api.nvim_set_keymap("v", "<A-j>", ":m '>+1<CR>gv-gv", n_opts)
vim.api.nvim_set_keymap("v", "<A-k>", ":m '<-2<CR>gv-gv", n_opts)

-- Toggle wrap
vim.api.nvim_set_keymap("n", "<F11>", "<cmd>set wrap!<CR>", ns_opts)

-- Close buffer
vim.api.nvim_set_keymap("n", "<Leader>w", "winnr('$') >= 2 ? ':close<CR>' : ':bd!<CR>'", nse_opts)

-- Enter normal mode in terminal
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", ns_opts)

-- Undo break points
local break_points = { ".", ",", "!", "?", "=", "-", "_" }
for _, v in pairs(break_points) do
	vim.api.nvim_set_keymap("i", tostring(v), v .. "<C-g>u", n_opts)
end

vim.api.nvim_set_keymap("n", "n", "nzz", n_opts)
vim.api.nvim_set_keymap("n", "N", "Nzz", n_opts)
