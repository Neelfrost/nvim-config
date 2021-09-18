-- Compile packer when pluginlist file changes
vim.cmd([[
    augroup PACKER_COMPILE_ONCHANGE
        autocmd!
        autocmd BufWritePost pluginlist.lua source <afile> | PackerCompile
    augroup END
]])

local packer = require("packerinit")
local use = packer.use

return packer.startup(function()
	-- Packer
	use({
		"wbthomason/packer.nvim",
	})

	-- Style
	use({
		"kyazdani42/nvim-web-devicons",
		config = function()
			require("plugins.devicons")
		end,
	})
	use({
		"sainnhe/gruvbox-material",
		config = function()
			require("themes").gruvbox()
		end,
	})
	use({
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		setup = function()
			require("plugins.indentline").setup()
		end,
		config = function()
			require("plugins.indentline").config()
		end,
	})
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("plugins.others").treesitter()
		end,
	})
	use({
		"p00f/nvim-ts-rainbow",
		event = "BufRead",
		after = "nvim-treesitter",
		config = function()
			require("plugins.others").ts_rainbow()
		end,
	})
	use({
		"norcalli/nvim-colorizer.lua",
		cmd = {
			"ColorizerToggle",
		},
	})

	-- Lsp stuff
	use({
		"ray-x/lsp_signature.nvim",
	})
	use({
		"fvictorio/vim-extract-variable",
		keys = "<Leader>ev",
	})
	use({
		"lervag/vimtex",
		ft = { "tex", "bib" },
		config = function()
			require("plugins.vimtex")
		end,
	})
	use({
		"hrsh7th/nvim-compe",
		event = "InsertEnter",
		config = function()
			require("plugins.compe")
		end,
	})
	use({
		"neovim/nvim-lspconfig",
		config = function()
			require("plugins.lsp")
		end,
	})
	use({
		"ThePrimeagen/refactoring.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
		config = function()
			require("plugins.others").refactoring()
		end,
	})

	-- Features
	use({
		"nvim-lua/plenary.nvim",
	})
	use({
		"nvim-lua/popup.nvim",
	})
	use({
		"tpope/vim-repeat",
	})
	use({
		"tpope/vim-surround",
	})
	use({
		"kevinhwang91/nvim-bqf",
	})
	use({
		"christoomey/vim-titlecase",
		keys = "gt",
	})
	use({
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
	})
	use({
		"junegunn/vim-easy-align",
		cmd = "EasyAlign",
	})
	use({
		"skywind3000/asyncrun.extra",
		after = "asyncrun.vim",
	})
	use({
		"skywind3000/asyncrun.vim",
		cmd = { "AsyncRun", "AsyncStop" },
	})
	use({
		"inkarkat/vim-SpellCheck",
		requires = { "inkarkat/vim-ingo-library" },
		cmd = { "SpellCheck", "SpellLCheck" },
	})
	use({
		"axvr/zepl.vim",
		cmd = { "Repl", "ReplSend" },
		ft = { "python" },
		config = function()
			require("plugins.others").zepl()
		end,
	})
	use({
		"terrortylor/nvim-comment",
		cmd = "CommentToggle",
		keys = { { "n", "gc" }, { "v", "gc" } },
		config = function()
			require("plugins.others").nvim_comment()
		end,
	})
	use({
		"dense-analysis/ale",
		event = "BufRead",
		config = function()
			require("plugins.ale")
		end,
	})
	use({
		"dhruvasagar/vim-open-url",
		keys = { { "n", "<Leader>u" }, { "n", "<Leader>s" } },
		config = function()
			require("plugins.others").openurl()
		end,
	})
	use({
		"ludovicchabant/vim-gutentags",
		ft = { "tex" },
		config = function()
			require("plugins.others").gutentags()
		end,
	})
	use({
		"nvim-telescope/telescope.nvim",
		config = function()
			require("plugins.telescope")
		end,
	})
	use({
		"phaazon/hop.nvim",
		event = "BufRead",
		config = function()
			require("plugins.hop")
		end,
	})
	use({
		"romgrk/barbar.nvim",
		config = function()
			require("plugins.barbar")
		end,
	})
	use({
		"SirVer/ultisnips",
		config = function()
			require("plugins.others").ultisnips()
		end,
	})
	use({
		"jiangmiao/auto-pairs",
		event = "InsertEnter",
		config = function()
			require("plugins.others").autopairs()
		end,
	})
	use({
		"Neelfrost/dashboard-nvim",
		event = "VimEnter",
		cmd = { "Dashboard", "SessionSave", "SessionLoad" },
		config = function()
			require("plugins.dashboard")
		end,
	})
	use({
		"kyazdani42/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeRefresh" },
		keys = { { "n", "<C-b>" } },
		config = function()
			require("plugins.nvimtree")
		end,
	})
	use({
		"shadmansaleh/lualine.nvim",
		config = function()
			require("plugins.lualine")
		end,
	})
	use({
		"antoinemadec/FixCursorHold.nvim",
		run = function()
			vim.g.curshold_updatime = 1000
		end,
	})
	use({
		"davidgranstrom/nvim-markdown-preview",
		ft = { "markdown" },
		config = function()
			vim.g.nvim_markdown_preview_theme = "github"
		end,
	})
	-- use('honza/vim-snippets')

	-- Automatic initial plugin installation
	if vim.fn.len(vim.fn.globpath(PACKER_PATH, "*", 0, 1)) == 1 then
		vim.cmd([[PackerSync]])
	end
end)
