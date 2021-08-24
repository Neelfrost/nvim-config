-- Compile packer when pluginlist file changes
vim.cmd([[autocmd BufWritePost pluginlist.lua source <afile> | PackerCompile]])

local packer = require("packerinit")

return packer.startup(function()
	-- Packer
	use({ "wbthomason/packer.nvim" })

	-- Style
	use({ "kyazdani42/nvim-web-devicons" })
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("plugins.others").indentline()
		end,
	})
	use({
		"p00f/nvim-ts-rainbow",
		config = function()
			require("plugins.ts-rainbow")
		end,
	})
	use({
		"sainnhe/gruvbox-material",
		config = function()
			require("theme").gruvbox()
		end,
	})
	use({
		"rose-pine/neovim",
		as = "rose-pine",
		config = function()
			require("theme").rosepine()
		end,
	})
	use({
		"srcery-colors/srcery-vim",
		config = function()
			require("theme").srcery()
		end,
	})

	-- Lsp stuff
	use({ "psf/black", branch = "stable", ft = "python", cmd = "Black" })
	use({
		"lervag/vimtex",
		config = function()
			require("plugins.vimtex")
		end,
	})
	use({
		"hrsh7th/nvim-compe",
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
		"glepnir/lspsaga.nvim",
		config = function()
			require("plugins.lspsaga")
		end,
	})
	use({ "ray-x/lsp_signature.nvim" })
	use({ "fvictorio/vim-extract-variable", ft = "python" })

	-- Features
	use({ "nvim-lua/plenary.nvim" })
	use({ "nvim-lua/popup.nvim" })
	use({ "tpope/vim-repeat" })
	use({ "tpope/vim-surround" })
	use({ "kevinhwang91/nvim-bqf" })
	use({ "junegunn/vim-easy-align", cmd = "EasyAlign" })
	use({ "skywind3000/asyncrun.extra", after = "asyncrun.vim" })
	use({ "skywind3000/asyncrun.vim", cmd = { "AsyncRun", "AsyncStop" } })
	use({ "inkarkat/vim-SpellCheck", requires = { "inkarkat/vim-ingo-library" }, cmd = { "SpellCheck", "SpellLCheck" } })
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("plugins.treesitter")
		end,
	})
	use({
		"axvr/zepl.vim",
		cmd = { "Repl", "ReplSend" },
		ft = { "py" },
		config = function()
			require("plugins.others").zepl()
		end,
	})
	use({
		"b3nj5m1n/kommentary",
		keys = { { "n", "<C-/>" }, { "i", "<C-/>" }, { "x", "<C-/>" } },
		config = function()
			require("plugins.kommentary")
		end,
	})
	use({ "christoomey/vim-titlecase" })
	use({
		"dense-analysis/ale",
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
		config = function()
			require("plugins.others").gutentags()
		end,
	})
	use({
		"nvim-telescope/telescope.nvim",
		commit = "d4a52ded6767ccda6c29e47332247003ac4c2007",
		config = function()
			require("plugins.telescope")
		end,
	})
	use({
		"phaazon/hop.nvim",
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
		"skywind3000/vim-terminal-help",
		event = "TermEnter",
		config = function()
			require("plugins.others").terminalhelp()
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
		keys = { { "n", "<C-b>" } },
		cmd = { "NvimTreeToggle", "NvimTreeRefresh" },
		config = function()
			require("plugins.nvimtree")
		end,
	})
	use({
		"hoob3rt/lualine.nvim",
		config = function()
			require("plugins.lualine")
		end,
	})
	-- use("windwp/nvim-autopairs") < missing features, using vim version instead >
	-- use('honza/vim-snippets')

	-- Automatic initial plugin installation
	if vim.fn.len(vim.fn.globpath(PACKER_PATH, "*", 0, 1)) == 1 then
		vim.cmd([[PackerSync]])
	end
end)
