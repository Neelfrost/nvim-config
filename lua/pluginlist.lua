-- Compile packer when pluginlist file changes
vim.cmd([[
    augroup PACKER_COMPILE_ONCHANGE
        autocmd!
        autocmd BufWritePost pluginlist.lua source <afile> | PackerCompile | colorscheme gruvbox-material
    augroup END
]])

local packer = require("packerinit")
local use = packer.use

return packer.startup(function()
    -- ------------------------------- Packer ------------------------------- --
    use({
        "wbthomason/packer.nvim",
    })

    -- ------------------------------- Themes ------------------------------- --
    use({
        "sainnhe/gruvbox-material",
        config = function()
            require("themes").gruvbox()
        end,
    })

    -- -------------------------------- Looks ------------------------------- --
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
        "kyazdani42/nvim-web-devicons",
        config = function()
            require("plugins.devicons")
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
        "norcalli/nvim-colorizer.lua",
        cmd = {
            "ColorizerToggle",
        },
    })

    -- --------------------------------- LSP -------------------------------- --
    use({
        "neovim/nvim-lspconfig",
        after = "cmp-nvim-lsp",
        config = function()
            require("plugins.lspconfig")
        end,
    })
    use({
        "ray-x/lsp_signature.nvim",
        after = "nvim-lspconfig",
        config = function()
            require("plugins.others").lsp_signature()
        end,
    })
    use({
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            require("plugins.null_ls")
        end,
    })
    use({
        "fvictorio/vim-extract-variable",
        keys = "<Leader>ev",
    })

    -- ----------------------------- Completion ----------------------------- --
    use({
        "hrsh7th/nvim-cmp",
        config = function()
            require("plugins.cmp")
        end,
    })
    use({
        "quangnguyen30192/cmp-nvim-ultisnips",
        after = "nvim-cmp",
    })
    use({
        "hrsh7th/cmp-nvim-lsp",
        after = "nvim-cmp",
    })
    use({
        "hrsh7th/cmp-buffer",
        after = "nvim-cmp",
    })
    use({
        "hrsh7th/cmp-omni",
        after = "nvim-cmp",
    })

    -- ------------------------------ Features ------------------------------ --
    use({
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
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
        "terrortylor/nvim-comment",
        cmd = "CommentToggle",
        keys = { { "n", "<C-/>" }, { "v", "<C-/>" }, { "n", "gc" }, { "v", "gc" } },
        config = function()
            require("plugins.others").nvim_comment()
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
        "goolord/alpha-nvim",
        config = function()
            require("plugins.alpha")
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
        "davidgranstrom/nvim-markdown-preview",
        ft = { "markdown" },
        config = function()
            vim.g.nvim_markdown_preview_theme = "github"
        end,
    })

    -- -------------------------------- LaTeX ------------------------------- --
    use({
        "lervag/vimtex",
        ft = { "tex", "bib" },
        config = function()
            require("plugins.vimtex")
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
        "SirVer/ultisnips",
        config = function()
            require("plugins.others").ultisnips()
        end,
    })

    -- ------------------------------ Telescope ----------------------------- --
    use({
        "nvim-telescope/telescope.nvim",
        config = function()
            require("plugins.telescope")
        end,
        requires = "nvim-lua/plenary.nvim",
    })
    use({
        "nvim-telescope/telescope-frecency.nvim",
        config = function()
            vim.g.sqlite_clib_path = "C:\\ProgramData\\chocolatey\\lib\\SQLite\\tools\\sqlite3.dll"
            require("telescope").load_extension("frecency")
        end,
        requires = { "tami5/sqlite.lua" },
    })
    use({
        "fhill2/telescope-ultisnips.nvim",
        cmd = "Telescope ultisnips",
    })
    use({
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
    })

    -- ------------------------- Buffer, Statusline ------------------------- --
    use({
        "noib3/cokeline.nvim",
        after = "telescope.nvim", -- Load after telescope so that highlights are defined
        config = function()
            require("plugins.cokeline")
        end,
    })
    use({
        "nvim-lualine/lualine.nvim",
        config = function()
            require("plugins.lualine")
        end,
    })

    -- --------------------------------- QOL -------------------------------- --
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
        keys = "gz",
    })
    use({
        "junegunn/vim-easy-align",
        cmd = "EasyAlign",
    })
    use({
        "phaazon/hop.nvim",
        event = "BufRead",
        config = function()
            require("plugins.hop")
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
        "antoinemadec/FixCursorHold.nvim",
        run = function()
            vim.g.curshold_updatime = 500
        end,
    })
    use({
        "Konfekt/FastFold",
        config = function()
            require("plugins.others").fastfold()
        end,
    })
    -- use({
    -- 	"honza/vim-snippets",
    -- })

    -- Automatic initial plugin installation
    if vim.fn.len(vim.fn.globpath(PACKER_PATH, "*", 0, 1)) == 1 then
        vim.cmd([[PackerSync]])
    end
end)
