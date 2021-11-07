-- Contains configs for plugins which require < 10 lines
local M = {}

function M.autopairs()
    vim.g.AutoPairsShortcutToggle = ""
    vim.api.nvim_set_keymap("i", "<C-l>", "<Esc><cmd>call AutoPairsJump()<CR>a", { noremap = true })
    vim.cmd([[
        augroup DEFINE_AUTOPAIRS
            autocmd!
            autocmd FileType lua,vim,md let b:AutoPairs = AutoPairsDefine({'<' : '>'})
        augroup END
    ]])
end

function M.gutentags()
    vim.g.gutentags_generate_on_new = 1
    vim.g.gutentags_generate_on_write = 1
    vim.g.gutentags_generate_on_missing = 1
    vim.g.gutentags_generate_on_empty_buffer = 0
end

function M.openurl()
    vim.g.open_url_default_mappings = 0
    vim.api.nvim_set_keymap("n", "<Leader>u", "<Plug>(open-url-browser)", {})
    vim.api.nvim_set_keymap("n", "<Leader>s", "<Plug>(open-url-search)", {})
end

function M.ultisnips()
    -- Disable snipmate plugins to avoid duplicate snippets
    vim.g.UltiSnipsEnableSnipMate = 0
    vim.g.UltiSnipsRemoveSelectModeMappings = 0
    vim.g.UltiSnipsExpandTrigger = "<Tab>"
    vim.g.UltiSnipsJumpForwardTrigger = "<Tab>"
    vim.g.UltiSnipsJumpBackwardTrigger = "<S-Tab>"
end

function M.treesitter()
    require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "comment", "lua", "c_sharp" },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        rainbow = {
            enable = true,
            extended_mode = true, -- Highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
        },
    })
end

function M.nvim_comment()
    require("nvim_comment").setup({
        comment_empty = false,
    })
    vim.api.nvim_set_keymap("n", "<C-/>", "<cmd>CommentToggle<CR>", { silent = true, noremap = true })
    vim.api.nvim_set_keymap(
        "v",
        "<C-/>",
        ":<C-u>call CommentOperator(visualmode())<CR>",
        { silent = true, noremap = true }
    )
end

function M.fastfold()
    vim.g.fastfold_savehook = 1
    vim.g.fastfold_fold_command_suffixes = { "x", "X", "a", "A", "o", "O", "c", "C", "m" }
    vim.g.fastfold_fold_movement_commands = { "]z", "[z", "zj", "zk" }
    vim.g.tex_fold_enabled = 1
end

function M.lsp_signature()
    require("lsp_signature").setup({
        bind = true,
        hint_enable = false,
        hint_prefix = "",
        floating_window = true,
        hi_parameter = "TelescopeBorder",
        extra_trigger_chars = { "(", "," },
        handler_opts = {
            border = "single",
        },
    })
end

function M.hop()
    require("hop").setup()

    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap("n", "S", "<cmd>HopChar2<CR>", opts)
    vim.api.nvim_set_keymap("n", "f", "<cmd>HopChar1<CR>", opts)
end

return M
