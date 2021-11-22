local map = vim.api.nvim_set_keymap
local n_opts = { noremap = true }
local ne_opts = { noremap = true, expr = true }
local ns_opts = { noremap = true, silent = true }
local nse_opts = { noremap = true, silent = true, expr = true }

-- Open windows terminal terminal at cwd
map(
    "n",
    "<Leader><Leader>t",
    "<cmd>lua launch_ext_prog('wt.exe -d', string.format('\"%s\"', vim.fn.expand('%:p:h')))<CR>",
    ns_opts
)

-- Open explorer at cwd
map("n", "<Leader><Leader>e", "<cmd>lua launch_ext_prog('explorer.exe', vim.fn.expand('%:p:h'))<CR>", ns_opts)

-- Open current file in vscode
map("n", "<Leader><Leader>c", "<cmd>lua launch_ext_prog('code', '%')<CR>", ns_opts)

-- Open current file in notepad
map("n", "<Leader><Leader>n", "<cmd>lua launch_ext_prog('notepad', '%')<CR>", ns_opts)

-- Replace word under cursor
map("n", "<F2>", [[:%s/\<<C-r><C-w>\>/]], n_opts)
map("v", "<F2>", [[y:%s/\V<C-r>"/]], n_opts)

-- Save file
map("n", "<C-s>", "<cmd>update!<CR>", ns_opts)
map("i", "<C-s>", "<Esc><cmd>update!<CR>", ns_opts)

-- Save and reload module
map("n", "<C-S-s>", "<cmd>lua save_reload_module()<CR>", ns_opts)

-- Toggle quickfix
map("n", "<Leader>q", "<cmd>QFix<CR>", ns_opts)

-- Format entire document
map("n", "<C-f>", "gg=G''zz<Esc>", ns_opts)

-- Toggle spell
map("n", "<F10>", "<cmd>setlocal spell!<CR>", ns_opts)

-- Remove highlight
map("n", "<Leader>h", "<cmd>nohl<CR>", ns_opts)

-- Map $ to g_
map("n", "$", "g_", n_opts)
map("v", "$", "g_", n_opts)

-- Yank till line end
map("n", "Y", '"+yg_', n_opts)

-- Always yank to clipboard
map("n", "y", '"+y', n_opts)
map("v", "y", '"+y', n_opts)

-- Paste from system clipboard in insert/select mode
map("i", "<C-v>", "<C-R>+", n_opts)
map("s", "<C-v>", "<BS>i<C-R>+", n_opts)

-- Toggle paste mode and paste from system clipboard
map("n", "<Leader>v", '<F12>"+P<F12>', n_opts)
map("i", "<Leader>v", '<ESC><F12>"+P<F12>i', n_opts)

-- Move to line end
map("i", "<C-a>", "<Esc>g_a", n_opts)

-- Display line movements
map("n", "j", "v:count == 0 ? 'gj' : 'j'", ne_opts)
map("n", "k", "v:count == 0 ? 'gk' : 'k'", ne_opts)
-- map("v", "j", "v:count == 0 ? 'gj' : 'j'", ne_opts)
-- map("v", "k", "v:count == 0 ? 'gk' : 'k'", ne_opts)

-- Fix accidental line joining during visual block selection
map("v", "J", "j", n_opts)
map("v", "K", "k", n_opts)

-- Correct previous bad word in insert mode
map("i", "<C-z>", "<C-g>u<Esc>[s1z=`]a<C-g>u", n_opts)
-- Correct word under cursor
map("n", "<C-z>", "1z=<Esc>", n_opts)

-- Delete previous word
map("i", "<C-BS>", "<C-w>", n_opts)
-- Delete next word
map("i", "<C-Del>", "<C-o>dW", n_opts)

-- Indenting
map("n", "<M-]>", ">>", n_opts)
map("n", "<M-[>", "<<", n_opts)

-- Continuous visual shifting https://superuser.com/q/310417/736190
map("x", "<M-]>", ">gv", n_opts)
map("x", "<M-[>", "<gv", n_opts)

-- Window switching
map("n", "<C-h>", "<C-w>h", n_opts)
map("n", "<C-l>", "<C-w>l", n_opts)
map("n", "<C-k>", "<C-w>k", n_opts)
map("n", "<C-j>", "<C-w>j", n_opts)

-- Disable word search on shift mouse
map("", "<S-LeftMouse>", "<nop>", {})
map("", "<S-LeftDrag>", "<nop>", {})

-- Command mode movement
map("c", "<C-j>", "<C-n>", n_opts)
map("c", "<C-k>", "<C-p>", n_opts)
map("c", "<C-h>", "<Left>", n_opts)
map("c", "<C-l>", "<Right>", n_opts)

-- Duplicate line
map("n", "<M-d>", "<cmd>t.<CR>", n_opts)
map("i", "<M-d>", "<Esc><cmd>t.<CR>gi", n_opts)

-- Move line / block
map("n", "<A-j>", ":m .+1<CR>==", n_opts)
map("n", "<A-k>", ":m .-2<CR>==", n_opts)
map("v", "<A-j>", ":m '>+1<CR>gv-gv", n_opts)
map("v", "<A-k>", ":m '<-2<CR>gv-gv", n_opts)

-- Toggle wrap
map("n", "<F11>", "<cmd>set wrap!<CR>", ns_opts)

-- Close buffer
map("n", "<Leader>w", "winnr('$') >= 2 ? ':close<CR>' : ':bd!<CR>'", nse_opts)

-- Enter normal mode in terminal
map("t", "<Esc>", "<C-\\><C-n>", ns_opts)

-- Center cursor after traversing search
map("n", "n", "nzz", n_opts)
map("n", "N", "Nzz", n_opts)

-- Undo break points
local break_points = { ".", ",", "!", "?", "=", "-", "_" }
for _, v in pairs(break_points) do
    map("i", tostring(v), v .. "<C-g>u", n_opts)
end
