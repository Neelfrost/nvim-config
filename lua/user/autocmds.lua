local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local group = augroup("on_bufenter", { clear = true })
autocmd("BufEnter", {
    callback = function()
        set_title()
    end,
    desc = "Set application window title.",
    group = group,
    pattern = "*",
})
autocmd("BufEnter", {
    callback = function()
        vim.opt_local.formatoptions:remove({ "r", "o" })
    end,
    desc = "After pressing <Enter> in insert mode, and on 'o' or 'O', disable inserting comment leader.",
    group = group,
    pattern = "*",
})

group = augroup("update_statuline", { clear = true })
autocmd("User", {
    command = [[redrawstatus]],
    desc = "Update lualine on lsp progress.",
    group = group,
    pattern = "LspProgressUpdate",
})

group = augroup("clean_onsave", { clear = true })
autocmd("BufWritePre", {
    callback = function()
        perform_cleanup()
    end,
    desc = "Remove trailing whitespace and newlines on save.",
    group = group,
    pattern = "*",
})

group = augroup("highlight_onyank", { clear = true })
autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 500, on_visual = true, on_macro = true })
    end,
    desc = "Highlight selection on yank.",
    group = group,
    pattern = "*",
})

group = augroup("update_file", { clear = true })
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    callback = function()
        local regex = vim.regex([[\(c\|r.?\|!\|t\)]])
        local mode = vim.api.nvim_get_mode()["mode"]
        if (not regex:match_str(mode)) and vim.fn.getcmdwintype() == "" then
            vim.cmd("checktime")
        end
    end,
    desc = "If the file is changed outside of neovim, reload it automatically.",
    group = group,
    pattern = "*",
})
autocmd("FileChangedShellPost", {
    callback = function()
        vim_notify("File changed on disk. Buffer reloaded!", vim.log.levels.WARN)
    end,
    desc = "If the file is changed outside of neovim, reload it automatically.",
    group = group,
    pattern = "*",
})

group = augroup("restore_cur_pos", { clear = true })
autocmd("BufReadPost", {
    command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"zz" | endif]],
    desc = "Restore cursor position to last known position on read.",
    group = group,
    pattern = "*",
})

-- Poor man's vim-rooter: https://www.reddit.com/r/neovim/comments/zy5s0l/you_dont_need_vimrooter_usually_or_how_to_set_up/
-- Array of file names indicating root directory. Modify to your liking.
local root_names = { ".git", "Makefile" }

-- Cache to use for speed up (at cost of possibly outdated results)
local root_cache = {}

local set_root = function()
    -- Get directory path to start search from
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" then
        return
    end
    path = vim.fs.dirname(path)

    -- Try cache and resort to searching upward for root directory
    local root = root_cache[path]
    if root == nil then
        local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
        -- If any in root_names is not found, set cwd to current directory
        if root_file == nil then
            vim.fn.chdir(path)
            return
        end
        root = vim.fs.dirname(root_file)
        root_cache[path] = root
    end

    -- Set current directory
    vim.fn.chdir(root)
end

group = augroup("MyAutoRoot", { clear = true })
autocmd("BufEnter", { group = group, callback = set_root })
