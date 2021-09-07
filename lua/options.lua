vim.cmd([[syntax on]])
vim.cmd([[filetype plugin indent on]])

-- File encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8 "
-- DOS fileformat
vim.opt.fileformat = "dos"

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
vim.opt.completeopt = { "menuone", "noselect" }
-- Show max. 10 completions
vim.opt.pumheight = 10

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Folding configuration
vim.opt.foldtext = "v:lua.custom_fold_text()"
vim.opt.viewoptions:remove("options")
vim.opt.foldmethod = "marker"

-- Display eol characters
vim.opt.list = true

-- Display chars
vim.opt.fillchars = { eob = "-", fold = " ", vert = "│" }
vim.opt.listchars = vim.opt.listchars + { tab = "··", lead = "·", eol = "﬋" }

-- Use en_us to spellcheck
vim.opt.spelllang = "en_us"

-- Enable moving between unsaved buffers
vim.opt.hidden = true

-- Statusline
vim.opt.laststatus = 2

-- No redraw during macro, regex execution
vim.opt.lazyredraw = true

-- Enable mouse for normal and visual modes
vim.opt.mouse = "nv"

-- Toggle paste mode
vim.opt.pastetoggle = "<F12>"

-- Lead scroll by 8 lines
vim.opt.scrolloff = 8

-- No completion messages in secondary mode bar
vim.opt.shortmess:append("c")

-- Disable secondary mode bar
vim.opt.showmode = false

-- No swap file
vim.opt.swapfile = false

vim.opt.startofline = false

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

-- Python3 path
vim.g.python3_host_prog = vim.fn.trim(vim.fn.system("which python"))

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

-- Disable Python2 support
vim.g.loaded_python_provider = 0

-- Disable perl provider
vim.g.loaded_perl_provider = 0

-- Disable ruby provider
vim.g.loaded_ruby_provider = 0

-- Disable node provider
vim.g.loaded_node_provider = 0
