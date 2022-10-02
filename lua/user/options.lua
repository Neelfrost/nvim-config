-- File encoding
vim.opt.fileencoding = "utf-8"

-- DOS fileformat
vim.opt.fileformat = "dos"
vim.opt.fileformats = "dos"

-- Enable dark background colorschemes
vim.opt.background = "dark"
-- Enable 24bit colors in terminal
vim.opt.termguicolors = true

-- Auto-indent new lines
vim.opt.autoindent = true
-- Enable smart-indent
vim.opt.smartindent = true

-- Use spaces instead of tabs
vim.opt.expandtab = true
-- Number of auto-indent spaces
vim.opt.shiftwidth = 4
-- Number of spaces per Tab
vim.opt.softtabstop = 4
-- Number of columns per tab
vim.opt.tabstop = 4

-- No wrap
vim.opt.wrap = false

-- Always case-insensitive
vim.opt.ignorecase = true
-- Enable smart-case search
vim.opt.smartcase = true
-- Searches for strings incrementally
vim.opt.incsearch = true

-- Show line numbers
vim.opt.number = true
-- Enable relative line numbers
vim.opt.relativenumber = true

-- Enable completion for vim-compe
vim.opt.completeopt = { "menu", "menuone", "noselect" }
-- Show max. 10 completions
vim.opt.pumheight = 10

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Folding configuration
vim.opt.viewoptions:remove("options")
vim.opt.foldmethod = "marker"

-- Display eol characters
vim.opt.list = true

-- Display chars
vim.opt.fillchars = {
    eob = "–",
    fold = " ",
    foldsep = " ",
    foldclose = "",
    foldopen = "",
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vert = "┃",
    vertleft = "┫",
    vertright = "┣",
    verthoriz = "╋",
}
vim.opt.listchars:append({ tab = " ", lead = "·", trail = "·", eol = "﬋" })

-- Use en_us to spellcheck
vim.opt.spelllang = "en_us"

-- Global statusline
vim.opt.laststatus = 3

-- Fold column
vim.opt.foldcolumn = "auto:9"
vim.opt.signcolumn = "yes"

-- No redraw during macro, regex execution
vim.opt.lazyredraw = true

-- Enable mouse for normal and visual modes
vim.opt.mouse = "nv"

-- Toggle paste mode
vim.opt.pastetoggle = "<F12>"

-- Lead scroll by 8 lines
vim.opt.scrolloff = 8

-- No completion messages in secondary mode bar
vim.opt.shortmess = "ilmxoOsTIcF"

-- Disable secondary mode bar
vim.opt.showmode = false

-- No swap file
vim.opt.swapfile = false

-- Real-time substitute
vim.opt.inccommand = "split"

-- Enable title
vim.opt.title = true

vim.opt.startofline = false

-- Cmdline height
vim.opt.ch = 0

-- Ignore LaTeX aux files
vim.opt.wildignore = {
    "*.aux",
    "*.lof",
    "*.lot",
    "*.fls",
    "*.out",
    "*.toc",
    "*.fmt",
    "*.fot",
    "*.cb",
    "*.cb2",
    ".*.lb",
    "__latex*",
    "*.fdb_latexmk",
    "*.synctex",
    "*.synctex(busy)",
    "*.synctex.gz",
    "*.synctex.gz(busy)",
    "*.pdfsync",
    "*.bbl",
    "*.bcf",
    "*.blg",
    "*.run.xml",
    "indent.log",
    "*.pdf",
}

-- Undo dir (persistent undo's)
local undo_dir = HOME_PATH .. [[\.cache\vim\undo]]
if not vim.fn.isdirectory(undo_dir) then
    vim.fn.mkdir(undo_dir)
end
vim.opt.undodir = undo_dir
vim.opt.undofile = true

-- Python3 path
vim.g.python3_host_prog = vim.fn.split(vim.fn.trim(vim.fn.system("where python")), "\n")[1]

-- Disable builtin vim plugins
local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "matchit",
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end

-- Disable perl provider
vim.g.loaded_perl_provider = 0

-- Disable ruby provider
vim.g.loaded_ruby_provider = 0

-- Disable node provider
vim.g.loaded_node_provider = 0
