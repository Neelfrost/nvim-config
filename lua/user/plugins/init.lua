-- Run ":PackerCompile" when this file changes
vim.cmd([[
    augroup PACKER_COMPILE_ONCHANGE
        autocmd!
        autocmd BufWritePost init.lua source <afile> | PackerCompile
    augroup END
]])

-- Install packer.nvim in "start" folder i.e., not lazy loaded {{{
local install_path = PACKER_PATH .. "\\start\\packer.nvim"
local packer_bootstrap

-- Check if packer.nvim is already installed
local present, packer = pcall(require, "packer")
if not present and vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    -- Install packer.nvim
    packer_bootstrap = vim.fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })

    -- Check for installation success
    vim.cmd("packadd packer.nvim")

    present, packer = pcall(require, "packer")
    if present then
        vim.notify("packer.nvim installation successful.", vim.log.levels.INFO)
    else
        vim.notify("packer.nvim installation failed.", vim.log.levels.ERROR)
        return
    end
end --}}}

-- Initialize packer.nvim {{{
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "single" })
        end,
        prompt_border = "single",
        working_sym = "",
        error_sym = "",
        done_sym = "",
    },
    auto_clean = true,
    compile_on_sync = true,
    max_jobs = 5,
}) --}}}

-- Plugin list
local use = packer.use
return packer.startup(function()
    -- ------------------------------- Packer ------------------------------- --
    use({
        "wbthomason/packer.nvim",
    })

    -- ------------------------------- Themes ------------------------------- --
    use({
        "themercorp/themer.lua",
        config = function()
            require("user.plugins.config.themer")
        end,
    })

    -- -------------------------------- Looks ------------------------------- --
    use({
        "nvim-treesitter/nvim-treesitter",
        event = "BufRead",
        run = ":TSUpdate",
        requires = { "nvim-ts-rainbow", "nvim-ts-autotag" },
    })
    use({
        "windwp/nvim-ts-autotag",
        after = "nvim-treesitter",
        requires = { "nvim-treesitter" },
    })
    use({
        "p00f/nvim-ts-rainbow",
        after = "nvim-treesitter",
        requires = { "nvim-treesitter" },
        config = function()
            require("user.plugins.config.others").treesitter()
        end,
    })
    use({
        "kyazdani42/nvim-web-devicons",
        config = function()
            require("user.plugins.config.devicons")
        end,
    })
    use({
        "lukas-reineke/indent-blankline.nvim",
        event = "BufRead",
        config = function()
            require("user.plugins.config.indentline")
        end,
    })
    use({
        "lukas-reineke/virt-column.nvim",
        cond = function()
            return vim.wo.colorcolumn ~= nil
        end,
        config = function()
            require("virt-column").setup()
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
        after = "nvim-cmp",
        requires = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            require("user.plugins.config.lspconfig")
        end,
    })
    use({
        "jose-elias-alvarez/null-ls.nvim",
        after = "nvim-cmp",
        requires = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            require("user.plugins.config.null_ls")
        end,
    })
    use({
        "ray-x/lsp_signature.nvim",
        after = "nvim-lspconfig",
        config = function()
            require("user.plugins.config.others").lsp_signature()
        end,
    })
    use({
        "fvictorio/vim-extract-variable",
        keys = "<Leader>ev",
    })
    use({
        "sbdchd/neoformat",
        cmd = "Neoformat",
        setup = function()
            vim.cmd([[
                augroup NEOFORMAT
                  autocmd!
                  autocmd BufWritePre * silent! undojoin | Neoformat
                augroup END
            ]])
        end,
        config = function()
            require("user.plugins.config.neoformat")
        end,
        disable = true,
    })

    -- ----------------------------- Completion ----------------------------- --
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            { "quangnguyen30192/cmp-nvim-ultisnips", after = "nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp", requires = "neovim/nvim-lspconfig" },
            { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
            { "hrsh7th/cmp-omni", after = "nvim-cmp" },
            { "hrsh7th/cmp-path", after = "nvim-cmp" },
            { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
        },
        config = function()
            require("user.plugins.config.cmp")
        end,
    })

    -- ------------------------------ Features ------------------------------ --
    use({
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        config = function()
            vim.g.startuptime_tries = 5
        end,
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
        keys = { { "n", "<C-/>" }, { "v", "<C-/>" }, { "i", "<C-/>" }, { "n", "gc" }, { "v", "gc" } },
        config = function()
            require("user.plugins.config.others").nvim_comment()
        end,
    })
    use({
        "jiangmiao/auto-pairs",
        event = "InsertEnter",
        config = function()
            require("user.plugins.config.others").autopairs()
        end,
    })
    use({
        "goolord/alpha-nvim",
        after = "themer.lua",
        config = function()
            require("user.plugins.config.alpha")
        end,
    })
    use({
        "kyazdani42/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeRefresh" },
        keys = { { "n", "<C-b>" } },
        config = function()
            require("user.plugins.config.nvimtree")
        end,
    })
    use({
        "iamcco/markdown-preview.nvim",
        cmd = "MarkdownPreview",
        ft = "markdown",
        run = "cd app && yarn install",
        config = function()
            require("user.plugins.config.others").markdown_preview()
        end,
    })
    use({
        "plasticboy/vim-markdown",
        ft = "markdown",
        config = function()
            vim.g.vim_markdown_frontmatter = 1
            vim.g.vim_markdown_folding_disabled = 1
        end,
    })
    use({
        "danymat/neogen",
        cmd = "Neogen",
        after = "nvim-treesitter",
        requires = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("user.plugins.config.others").neogen()
        end,
    })

    -- -------------------------------- LaTeX ------------------------------- --
    use({
        "lervag/vimtex",
        ft = { "tex", "bib" },
        config = function()
            require("user.plugins.config.vimtex")
        end,
    })
    use({
        "ludovicchabant/vim-gutentags",
        ft = { "tex" },
        config = function()
            require("user.plugins.config.others").gutentags()
        end,
    })
    use({
        "SirVer/ultisnips",
        config = function()
            require("user.plugins.config.others").ultisnips()
        end,
    })

    -- ------------------------------ Telescope ----------------------------- --
    use({
        "nvim-telescope/telescope.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("user.plugins.config.telescope")
        end,
    })
    use({
        "nvim-telescope/telescope-frecency.nvim",
        requires = { "tami5/sqlite.lua" },
        config = function()
            vim.g.sqlite_clib_path = "C:\\ProgramData\\chocolatey\\lib\\SQLite\\tools\\sqlite3.dll"
        end,
    })
    use({
        "fhill2/telescope-ultisnips.nvim",
    })
    use({
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
    })

    -- ------------------------- Buffer, Statusline ------------------------- --
    use({
        "noib3/nvim-cokeline",
        after = "themer.lua",
        config = function()
            require("user.plugins.config.cokeline")
        end,
    })
    use({
        "nvim-lualine/lualine.nvim",
        after = "themer.lua",
        config = function()
            require("user.plugins.config.lualine")
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
        "https://gitlab.com/yorickpeterse/nvim-pqf",
        as = "nvim-pqf",
        event = "BufRead",
        config = function()
            require("pqf").setup()
        end,
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
            require("user.plugins.config.others").hop()
        end,
    })
    use({
        "dhruvasagar/vim-open-url",
        keys = { { "n", "<Leader>u" }, { "n", "<Leader>s" } },
        config = function()
            require("user.plugins.config.others").openurl()
        end,
    })
    use({
        "antoinemadec/FixCursorHold.nvim",
        event = "BufRead",
        config = function()
            vim.g.curshold_updatime = 500
        end,
    })
    use({
        "Konfekt/FastFold",
        event = "BufRead",
        config = function()
            require("user.plugins.config.others").fastfold()
        end,
    })
    use({
        "Shatur/neovim-session-manager",
        cmd = "SessionManager",
        config = function()
            require("user.plugins.config.others").session()
        end,
    })
    use({
        "ethanholz/nvim-lastplace",
        config = function()
            require("nvim-lastplace").setup()
        end,
    })

    -- use({
    --     "honza/vim-snippets",
    -- })

    -- Automatic initial plugin installation
    if packer_bootstrap then
        packer.sync()
    end
end)
