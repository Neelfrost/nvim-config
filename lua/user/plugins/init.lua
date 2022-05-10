-- Compile on change autocmd{{{
local group = vim.api.nvim_create_augroup("packer_compile_onchange", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    command = [[source <afile> | PackerCompile]],
    desc = "Run ':PackerCompile' when this file changes.",
    group = group,
    pattern = "*/plugins/init.lua",
}) --}}}

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
        vim_notify("packer.nvim installation successful.", vim.log.levels.INFO)
    else
        vim_notify("packer.nvim installation failed.", vim.log.levels.ERROR)
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
        config = function()
            require("user.plugins.config.others").treesitter()
        end,
    })
    use({
        "windwp/nvim-ts-autotag",
        ft = { "html", "javascript", "xml", "markdown" },
        requires = { "nvim-treesitter" },
    })
    use({
        "p00f/nvim-ts-rainbow",
        ft = PARSERS,
        requires = { "nvim-treesitter" },
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
            vim.api.nvim_create_autocmd("BufWritePre", {
                command = [[silent! undojoin | Neoformat]],
                desc = "Format using neoformat on save.",
                group = vim.api.nvim_create_augroup("neoformat_format_onsave", { clear = true }),
                pattern = "*",
            })
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
            { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp", requires = "neovim/nvim-lspconfig" },
            { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
            { "hrsh7th/cmp-omni", after = "nvim-cmp" },
            { "hrsh7th/cmp-path", after = "nvim-cmp" },
            { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
            { "quangnguyen30192/cmp-nvim-ultisnips", after = "nvim-cmp" },
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
        "iamcco/markdown-preview.nvim",
        cmd = "MarkdownPreview",
        ft = "markdown",
        run = "cd app && yarn install",
        config = function()
            require("user.plugins.config.others").markdown_preview()
        end,
    })
    use({
        "danymat/neogen",
        cmd = "Neogen",
        requires = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("user.plugins.config.others").neogen()
        end,
    })
    use({
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("user.plugins.config.neotree")
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
        config = function()
            require("user.plugins.config.others").session()
        end,
    })
    use({
        "anuvyklack/pretty-fold.nvim",
        config = function()
            require("user.plugins.config.pretty_fold")
        end,
    })

    -- Automatic initial plugin installation
    if packer_bootstrap then
        packer.sync()
    end
end)
