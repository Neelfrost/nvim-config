-- https://github.com/quangnguyen30192/cmp-nvim-ultisnips/blob/main/lua/cmp_nvim_ultisnips/mappings.lua
local cmp = require("cmp")

local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
    mode = mode or "m"
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local can_execute = function(arg)
    return vim.fn[arg]() == 1
end

local valid_actions = {
    expand = {
        condition = { can_execute, "UltiSnips#CanExpandSnippet" },
        command = { feedkey, "<Plug>(cmpu-expand)" },
    },
    jump_forwards = {
        condition = { can_execute, "UltiSnips#CanJumpForwards" },
        command = { feedkey, "<Plug>(cmpu-jump-forwards)" },
    },
    jump_backwards = {
        condition = { can_execute, "UltiSnips#CanJumpBackwards" },
        command = { feedkey, "<Plug>(cmpu-jump-backwards)" },
    },
    confirm = {
        condition = { has_words_before },
        command = { cmp.confirm, { select = true } },
    },
}

local M = {}

---Executes a command when condition match
---@param actions table list of actions to execute
M.compose = function(actions)
    return function(fallback)
        for _, v in ipairs(actions) do
            local action = valid_actions[v]
            if not action then
                vim.notify(
                    ('[cmp_mappings] Invalid action ("%s"). Please check your mappings.\nAllowed values: { %s }'):format(
                        v,
                        table.concat(vim.tbl_keys(valid_actions), ", ")
                    ),
                    vim.log.levels.ERROR
                )
                return
            end
            if action.condition[1](action.condition[2]) == true then
                action.command[1](action.command[2])
                return
            end
        end
        fallback()
    end
end

return M
