local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set
local e_opts = { expr = true }
local s_opts = { silent = true }
local se_opts = { silent = true, expr = true }

-- Contains configs for plugins
local M = {}

M.autopairs = function()
    vim.g.AutoPairsShortcutToggle = ""
    map("i", "<C-l>", "<Esc><cmd>call AutoPairsJump()<CR>a", s_opts)
    local group = augroup("custom_autopairs", { clear = true })
    autocmd("Filetype", {
        command = [[let b:AutoPairs = AutoPairsDefine({'<' : '>'})]],
        desc = "Add angle brackets as an autopair.",
        group = group,
        pattern = { "lua", "vim", "md", "html", "xml" },
    })
    autocmd("Filetype", {
        command = [[let b:AutoPairs = {'(':')', '[':']', '{':'}', "'":"'", '"':'"', "`":"'", '``':"''"}]],
        desc = "Add latex quotes as autopairs.",
        group = group,
        pattern = "tex",
    })
end

M.gutentags = function()
    vim.g.gutentags_generate_on_new = 1
    vim.g.gutentags_generate_on_write = 1
    vim.g.gutentags_generate_on_missing = 1
    vim.g.gutentags_generate_on_empty_buffer = 0
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
        ensure_installed = PARSERS,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        rainbow = {
            enable = true,
            extended_mode = true, -- Highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
        },
        autotag = {
            enable = true,
        },
    })
end

M.nvim_comment = function()
    require("nvim_comment").setup({ comment_empty = false })
    map("i", "<C-/>", "<C-o><cmd>CommentToggle<CR><C-o>A", s_opts)
    map("n", "<C-/>", "<cmd>CommentToggle<CR>", s_opts)
    map("v", "<C-/>", ":<C-u>call CommentOperator(visualmode())<CR>", s_opts)
end

M.fastfold = function()
    vim.g.fastfold_savehook = 0
    vim.g.fastfold_fold_command_suffixes = { "x", "X" }
    vim.g.fastfold_fold_movement_commands = { "]z", "[z", "zj", "zk" }
end

M.lsp_signature = function()
    require("lsp_signature").setup({
        bind = true,
        hint_enable = false,
        hint_prefix = "",
        floating_window = true,
        hi_parameter = "ThemerHeadingH1",
        extra_trigger_chars = { "(", "," },
        handler_opts = {
            border = "single",
        },
    })
end

M.hop = function()
    require("hop").setup()
    map("n", "S", "<cmd>HopChar2<CR>", s_opts)
    map("n", "f", "<cmd>HopChar1<CR>", s_opts)
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
    map("n", "<Leader>ss", "<cmd>SessionManager save_current_session<CR>", s_opts)
    map("n", "<Leader>ls", "<cmd>SessionManager load_session<CR>", s_opts)
end

M.markdown_preview = function()
    -- https://github.com/wbthomason/packer.nvim/issues/620
    vim.cmd("doautocmd mkdp_init BufEnter")
    vim.g.mkdp_auto_close = 0
    vim.g.mkdp_page_title = "${name}"
end

M.neogen = function()
    require("neogen").setup({ enabled = true })
end

M.refactoring = function()
    vim.api.nvim_create_user_command("ExtractFunction", function()
        require("refactoring").refactor("Extract Function")
    end, {
        force = true,
        range = true,
    })
    vim.api.nvim_create_user_command("ExtractVariable", function()
        require("refactoring").refactor("Extract Variable")
    end, {
        force = true,
        range = true,
    })
    vim.api.nvim_create_user_command("ExtractFunctionToFile", function()
        require("refactoring").refactor("Extract Function To File")
    end, {
        force = true,
        range = true,
    })
end

return M
