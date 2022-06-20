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
    compile_path = CONFIG_PATH .. "/plugin/packer_compiled.lua", -- for impatient caching
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
    autoremove = true,
}) --}}}

-- Plugin list
local use = packer.use
return packer.startup(function()
    -- ------------------------------- Packer ------------------------------- --
    use({
        "wbthomason/packer.nvim",
    })

    -- ------------------------------ Impatient ----------------------------- --
    use({
        "lewis6991/impatient.nvim",
    })

    -- ------------------------------- Themes ------------------------------- --
    use({
        "themercorp/themer.lua",
        config = 'require("user.plugins.config.themer")',
    })

    -- -------------------------------- Looks ------------------------------- --
    use({
        "nvim-treesitter/nvim-treesitter",
        event = "BufRead",
        run = ":TSUpdate",
        requires = { "nvim-ts-rainbow", "nvim-ts-autotag" },
        config = 'require("user.plugins.config.others").treesitter()',
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
        config = 'require("user.plugins.config.devicons")',
    })
    use({
        "lukas-reineke/indent-blankline.nvim",
        event = "BufRead",
        config = 'require("user.plugins.config.indentline")',
    })
    use({
        "lukas-reineke/virt-column.nvim",
        event = "BufRead",
        config = 'require("virt-column").setup()',
    })
    use({
        "RRethy/vim-hexokinase",
        run = "make",
        cmd = { "HexokinaseToggle" },
        config = function()
            vim.g.Hexokinase_optInPatterns = "full_hex,rgb,rgba,hsl,hsla"
        end,
    })

    -- --------------------------------- LSP -------------------------------- --
    use({
        "neovim/nvim-lspconfig",
        after = "nvim-cmp",
        requires = { "hrsh7th/cmp-nvim-lsp" },
        config = 'require("user.plugins.config.lspconfig")',
    })
    use({
        "jose-elias-alvarez/null-ls.nvim",
        config = 'require("user.plugins.config.null_ls")',
    })
    use({
        "ray-x/lsp_signature.nvim",
        after = "nvim-lspconfig",
        config = 'require("user.plugins.config.others").lsp_signature()',
    })
    use({
        "ThePrimeagen/refactoring.nvim",
        after = "nvim-treesitter",
        requires = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
        config = 'require("user.plugins.config.others").refactoring()',
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
        config = 'require("user.plugins.config.neoformat")',
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
        config = 'require("user.plugins.config.cmp")',
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
        config = 'require("user.plugins.config.others").nvim_comment()',
    })
    use({
        "jiangmiao/auto-pairs",
        config = 'require("user.plugins.config.others").autopairs()',
    })
    use({
        "goolord/alpha-nvim",
        after = "themer.lua",
        config = 'require("user.plugins.config.alpha")',
    })
    use({
        "iamcco/markdown-preview.nvim",
        cmd = "MarkdownPreview",
        ft = "markdown",
        run = "cd app && yarn install",
        config = 'require("user.plugins.config.others").markdown_preview()',
    })
    use({
        "danymat/neogen",
        cmd = "Neogen",
        requires = { "nvim-treesitter/nvim-treesitter" },
        config = 'require("user.plugins.config.others").neogen()',
    })
    use({
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
        config = 'require("user.plugins.config.neotree")',
    })

    -- -------------------------------- LaTeX ------------------------------- --
    use({
        "lervag/vimtex",
        ft = { "tex", "bib" },
        config = 'require("user.plugins.config.vimtex")',
    })
    use({
        "ludovicchabant/vim-gutentags",
        ft = { "tex" },
        config = 'require("user.plugins.config.others").gutentags()',
    })
    use({
        "SirVer/ultisnips",
        config = 'require("user.plugins.config.others").ultisnips()',
    })

    -- ------------------------------ Telescope ----------------------------- --
    use({
        "nvim-telescope/telescope.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = 'require("user.plugins.config.telescope")',
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
        config = 'require("user.plugins.config.cokeline")',
    })
    use({
        "rebelot/heirline.nvim",
        after = "themer.lua",
        requires = { { "lewis6991/gitsigns.nvim", config = "require('user.plugins.config.gitsigns')" } },
        config = 'require("user.plugins.config.heirline")',
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
        config = 'require("pqf").setup()',
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
        config = 'require("user.plugins.config.others").hop()',
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
        config = 'require("user.plugins.config.others").fastfold()',
    })
    use({
        "Shatur/neovim-session-manager",
        config = 'require("user.plugins.config.others").session()',
    })
    use({
        "anuvyklack/pretty-fold.nvim",
        config = 'require("user.plugins.config.pretty_fold")',
    })

    -- Automatic initial plugin installation
    if packer_bootstrap then
        packer.sync()
    end
end)
