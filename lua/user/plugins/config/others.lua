local map = vim.api.nvim_set_keymap
local n_opts = { noremap = true }
local ne_opts = { noremap = true, expr = true }
local ns_opts = { noremap = true, silent = true }
local nse_opts = { noremap = true, silent = true, expr = true }

-- Contains configs for plugins which require < 10 lines
local M = {}

M.autopairs = function()
    vim.g.AutoPairsShortcutToggle = ""
    map("i", "<C-l>", "<Esc><cmd>call AutoPairsJump()<CR>a", ns_opts)
    vim.cmd([[
        augroup DEFINE_AUTOPAIRS
            autocmd!
            autocmd FileType lua,vim,md,html,xml let b:AutoPairs = AutoPairsDefine({'<' : '>'})
        augroup END
    ]])
end

M.gutentags = function()
    vim.g.gutentags_generate_on_new = 1
    vim.g.gutentags_generate_on_write = 1
    vim.g.gutentags_generate_on_missing = 1
    vim.g.gutentags_generate_on_empty_buffer = 0
end

M.openurl = function()
    vim.g.open_url_default_mappings = 0
    map("n", "<Leader>u", "<Plug>(open-url-browser)", {})
    map("n", "<Leader>s", "<Plug>(open-url-search)", {})
end

M.ultisnips = function()
    -- Disable snipmate plugins to avoid duplicate snippets
    vim.g.UltiSnipsEnableSnipMate = 0
    vim.g.UltiSnipsRemoveSelectModeMappings = 0
    vim.g.UltiSnipsExpandTrigger = "<Tab>"
    vim.g.UltiSnipsJumpForwardTrigger = "<Tab>"
    vim.g.UltiSnipsJumpBackwardTrigger = "<S-Tab>"
end

M.treesitter = function()
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

M.nvim_comment = function()
    require("nvim_comment").setup({
        comment_empty = false,
    })
    map("i", "<C-/>", "<C-o><cmd>CommentToggle<CR><C-o>A", ns_opts)
    map("n", "<C-/>", "<cmd>CommentToggle<CR>", ns_opts)
    map("v", "<C-/>", ":<C-u>call CommentOperator(visualmode())<CR>", ns_opts)
end

M.fastfold = function()
    vim.g.fastfold_minlines = 0
    vim.g.fastfold_savehook = 0
    vim.g.fastfold_fold_command_suffixes = { "x", "X", "a", "A", "o", "O", "c", "C", "m" }
    vim.g.fastfold_fold_movement_commands = { "]z", "[z", "zj", "zk" }
end

M.lsp_signature = function()
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

M.hop = function()
    require("hop").setup()
    map("n", "S", "<cmd>HopChar2<CR>", ns_opts)
    map("n", "f", "<cmd>HopChar1<CR>", ns_opts)
end

M.session = function()
    local path = require("plenary.path")
    require("session_manager").setup({
        sessions_dir = path:new(vim.fn.stdpath("data"), "sessions"),
        path_replacer = "__",
        colon_replacer = "++",
        autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
        autosave_last_session = false,
        autosave_ignore_not_normal = true,
        autosave_only_in_session = true,
    })
    map("n", "<Leader>ss", "<cmd>SessionManager save_current_session<CR>", ns_opts)
    map("n", "<Leader>ls", "<cmd>SessionManager load_session<CR>", ns_opts)
end

M.markdown_preview = function()
    -- https://github.com/wbthomason/packer.nvim/issues/620
    vim.cmd("doautocmd mkdp_init BufEnter")
    vim.g.mkdp_auto_close = 0
    vim.g.mkdp_page_title = "${name}"
end

return M
