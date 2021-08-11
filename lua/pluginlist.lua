-- Compile oacker when pluginlist file changes
vim.cmd([[autocmd BufWritePost pluginlist.lua source <afile> | PackerCompile]])

local install_path = PACKER_PATH .. "\\packer.nvim"

-- Check if packer is installed, if not install packer
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	print("Installing packer.nvim.")
	vim.cmd([[
        highlight Normalfloat guibg=NONE
        highlight Floatborder guibg=NONE
    ]])
	vim.fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.cmd([[packadd packer.nvim]])
	print("Installation complete.\nStarting plugin installation.")
end

local packer = require("packer")

-- Initialize floating window for packer
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "single" })
		end,
	},
	git = {
		clone_timeout = 600, -- Timeout, in seconds, for git clones
	},
})

return packer.startup(function()
	-- Packer
	use({ "wbthomason/packer.nvim" })

	-- Style
	use({ "kyazdani42/nvim-web-devicons" })
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("plugins.indentline")
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

	-- Lsp stuff
	use({ "psf/black", branch = "stable", ft = "py", cmd = "Black" })
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

	-- Features
	use({ "nvim-lua/plenary.nvim" })
	use({ "nvim-lua/popup.nvim" })
	use({ "tpope/vim-repeat" })
	use({ "tpope/vim-surround" })
	use({ "kevinhwang91/nvim-bqf", cmd = "QFix" })
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
			require("plugins.zepl")
		end,
	})
	use({
		"b3nj5m1n/kommentary",
		keys = { "<C-/>" },
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
		keys = { "<Leader>u", "<Leader>s" },
		config = function()
			require("plugins.open-url")
		end,
	})
	use({
		"ludovicchabant/vim-gutentags",
		config = function()
			require("plugins.gutentags")
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
			require("plugins.ultisnips")
		end,
	})
	use({
		"skywind3000/vim-terminal-help",
		event = "TermEnter",
		config = function()
			require("plugins.terminal-help")
		end,
	})
	use({
		"jiangmiao/auto-pairs",
		event = "InsertEnter",
		config = function()
			require("plugins.autopairs")
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
		keys = { "<C-b>" },
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
		vim.cmd([[redraw! | PackerSync]])
	end
end)
