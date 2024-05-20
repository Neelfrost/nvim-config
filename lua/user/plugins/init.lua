local lazypath = LAZY_PATH .. "/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- ------------------------------- Themes ------------------------------- --
    {
        "ThemerCorp/themer.lua",
        config = function()
            require("user.plugins.config.themer")
        end,
    },

    -- -------------------------------- Looks ------------------------------- --
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "HiPhish/rainbow-delimiters.nvim",
            "windwp/nvim-ts-autotag",
            -- "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            require("user.plugins.config.treesitter")
        end,
        build = ":TSUpdate",
    },
    {
        "nvim-treesitter/playground",
        dependencies = "nvim-treesitter/nvim-treesitter",
        enabled = false,
    },
    {
        "kyazdani42/nvim-web-devicons",
        config = function()
            require("user.plugins.config.devicons")
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("user.plugins.config.indentline")
        end,
    },
    {
        "lukas-reineke/virt-column.nvim",
        config = true,
    },
    {
        "RRethy/vim-hexokinase",
        config = function()
            vim.g.Hexokinase_optInPatterns = "full_hex,rgb,rgba,hsl,hsla"
        end,
        build = "make hexokinase",
        cmd = "HexokinaseToggle",
    },

    -- --------------------------------- LSP -------------------------------- --
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("user.plugins.config.lspconfig")
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            require("user.plugins.config.null_ls")
        end,
    },
    {
        "ray-x/lsp_signature.nvim",
        dependencies = "nvim-lspconfig",
        config = function()
            require("user.plugins.config.others").lsp_signature()
        end,
    },
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        init = function()
            require("user.plugins.config.others").refactoring()
        end,
    },
    {
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
        enabled = false,
    },

    -- ----------------------------- Completion ----------------------------- --
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lua",
            "quangnguyen30192/cmp-nvim-ultisnips",
            { "hrsh7th/cmp-omni", ft = "tex" },
        },
        config = function()
            require("user.plugins.config.cmp")
        end,
        event = "InsertEnter",
    },

    -- ------------------------------ Features ------------------------------ --
    {
        "dstein64/vim-startuptime",
        config = function()
            vim.g.startuptime_tries = 5
            vim.g.startuptime_event_width = 50
        end,
        cmd = "StartupTime",
    },
    {
        "is0n/jaq-nvim",
        config = function()
            require("user.plugins.config.jaq")
        end,
    },
    {
        "terrortylor/nvim-comment",
        config = function()
            require("user.plugins.config.others").nvim_comment()
        end,
        cmd = "CommentToggle",
        keys = {
            { mode = "n", "<C-/>" },
            { mode = "v", "<C-/>" },
            { mode = "i", "<C-/>" },
            { mode = "n", "gc" },
            { mode = "v", "gc" },
        },
    },
    {
        "jiangmiao/auto-pairs",
        config = function()
            require("user.plugins.config.others").autopairs()
        end,
        event = "InsertEnter",
    },
    {
        "goolord/alpha-nvim",
        config = function()
            require("user.plugins.config.alpha")
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        config = function()
            require("user.plugins.config.others").markdown_preview()
        end,
        cmd = "MarkdownPreview",
        ft = "markdown",
        build = "cd app && yarn install",
    },
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("user.plugins.config.others").neogen()
        end,
        cmd = "Neogen",
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("user.plugins.config.neotree")
        end,
        keys = "<C-b>",
    },
    {
        "Shatur/neovim-session-manager",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            require("user.plugins.config.others").session()
        end,
        cmd = "SessionManager",
        keys = {
            { mode = "n", "<Leader>ss" },
            { mode = "n", "<Leader>ls" },
        },
    },
    {
        "phaazon/hop.nvim",
        version = "2.x",
        config = function()
            require("user.plugins.config.others").hop()
        end,
        keys = {
            { mode = "n", "f" },
            { mode = "n", "S" },
            { mode = "o", "f" },
        },
    },
    {
        "kylechui/nvim-surround",
        opts = {
            highlight = { duration = 500 },
            move_cursor = false,
        },
    },
    {
        "mg979/vim-visual-multi",
        config = function()
            vim.g.VM_set_statusline = 0
        end,
        keys = {
            { mode = "n", "<C-n>" },
            { mode = "n", "<C-Down>" },
            { mode = "n", "<C-Up>" },
        },
    },

    -- -------------------------------- LaTeX ------------------------------- --
    {
        "lervag/vimtex",
        config = function()
            require("user.plugins.config.vimtex")
        end,
        ft = {
            "tex",
            "bib",
        },
    },
    {
        "ludovicchabant/vim-gutentags",
        config = function()
            require("user.plugins.config.others").gutentags()
        end,
        ft = {
            "tex",
            "bib",
        },
    },
    {
        "SirVer/ultisnips",
        config = function()
            require("user.plugins.config.others").ultisnips()
        end,
        event = "InsertEnter",
    },

    -- ------------------------------ Telescope ----------------------------- --
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
            {
                "nvim-telescope/telescope-frecency.nvim",
            },
            "fhill2/telescope-ultisnips.nvim",
        },
        config = function()
            require("user.plugins.config.telescope")
        end,
        cmd = "Telescope",
        keys = { "tr", "tf", "tp", "tn", "tl", "ts", "<F5>", "<F6>" },
    },

    -- ------------------------- Buffer, Statusline ------------------------- --
    {
        "willothy/nvim-cokeline",
        config = function()
            require("user.plugins.config.cokeline")
        end,
        dependencies = "ThemerCorp/themer.lua",
    },
    {
        "rebelot/heirline.nvim",
        dependencies = {
            "ThemerCorp/themer.lua",
            {
                "lewis6991/gitsigns.nvim",
                config = function()
                    require("user.plugins.config.gitsigns")
                end,
                lazy = true,
            },
        },
        config = function()
            require("user.plugins.config.heirline")
        end,
    },

    -- --------------------------------- QOL -------------------------------- --
    {
        "tpope/vim-repeat",
    },
    {
        "https://gitlab.com/yorickpeterse/nvim-pqf",
        config = function()
            require("pqf").setup()
        end,
        name = "nvim-pqf",
        event = "VeryLazy",
    },
    {
        "christoomey/vim-titlecase",
        keys = "gz",
    },
    {
        "junegunn/vim-easy-align",
        cmd = "EasyAlign",
    },
    {
        "antoinemadec/FixCursorHold.nvim",
        config = function()
            vim.g.curshold_updatime = 500
        end,
    },
    {
        "Konfekt/FastFold",
        config = function()
            require("user.plugins.config.others").fastfold()
        end,
    },
    {
        "anuvyklack/pretty-fold.nvim",
        config = function()
            require("user.plugins.config.pretty_fold")
        end,
    },
    {
        "rmagatti/alternate-toggler",
        config = function()
            vim.keymap.set("n", "ta", "<Cmd>:ToggleAlternate<CR>")
        end,
        cmd = "ToggleAlternate",
        keys = "ta",
    },
})
