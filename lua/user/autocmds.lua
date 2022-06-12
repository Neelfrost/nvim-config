local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local group = augroup("on_bufenter", { clear = true })
autocmd("BufEnter", {
    command = [[silent! lcd %:p:h]],
    desc = "Set the parent directory of the current file as cwd.",
    group = group,
    pattern = "*.*",
})
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
