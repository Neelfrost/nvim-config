local M = {}

local fn = vim.fn
local half_winwidth = 91

M.buffer_is_plugin = function() --{{{
    local filename = fn.expand("%:t")
    for _, v in pairs(PLUGINS) do
        if filename == v or vim.bo.filetype == v then
            return true
        end
    end
end --}}}

M.file_icon = function(file_name, file_type) --{{{
    local icon = ""
    if file_type ~= "" then
        icon = require("nvim-web-devicons").get_icon(file_name, file_type)
    end

    -- Return file_name if icon does not exist
    if icon == nil or icon == "" then
        return file_name
    end

    -- Join icon and file_name if icon exists
    return icon .. " " .. file_name
end --}}}

M.file_name = function() --{{{
    local file_name = fn.expand("%:r")
    local file_type = fn.expand("%:e")

    -- Truncate file_name if too big
    -- Set file name to [No Name] on empty buffers
    if #file_name > 15 then
        file_name = string.sub(file_name, 1, 8) .. "⋯"
    elseif file_name == "" then
        file_name = "[No Name]"
    end

    -- Join file_name and file_type if file_type exists
    local final_name = file_type ~= "" and file_name .. "." .. file_type or file_name

    -- Empty file_name for plugin releated buffers
    for _, v in pairs(PLUGINS) do
        if v == vim.bo.filetype then
            final_name = "⋯"
        end
    end

    return M.readonly() .. M.file_icon(final_name, file_type)
end --}}}

M.readonly = function() --{{{
    local readonly = vim.api.nvim_exec([[echo &readonly || !&modifiable ? ' ' : '']], true)
    return readonly
end --}}}

M.current_mode = function() --{{{
    local buffer_name = fn.expand("%:t")
    local mode = require("lualine.utils.mode").get_mode()
    local mode_plugins = {
        NvimTree = "NVIMTREE",
        packer = "PACKER",
        dashboard = "DASHBOARD",
        alpha = "ALPHA",
    }

    -- Return mode if in command mode
    if fn.mode() == "c" then
        return mode
    end

    -- Return plugin name
    for k, v in pairs(mode_plugins) do
        if vim.bo.filetype == k or buffer_name == k then
            return v
        end
    end

    -- Return mode
    return mode
end --}}}

M.paste = function() --{{{
    return vim.o.paste and "" or ""
end --}}}

M.wrap = function() --{{{
    return vim.o.wrap and "" or ""
end --}}}

M.spell = function() --{{{
    return vim.wo.spell and vim.bo.spelllang or ""
end --}}}

M.file_format = function() --{{{
    if not M.buffer_is_plugin() and fn.winwidth(0) > half_winwidth then
        return vim.bo.fileformat
    else
        return ""
    end
end --}}}

M.file_encoding = function() --{{{
    if not M.buffer_is_plugin() and fn.winwidth(0) > half_winwidth then
        return vim.bo.fileencoding
    else
        return ""
    end
end --}}}

M.buffer_percent = function() --{{{
    return fn.winwidth(0) > half_winwidth and string.format(
        "並%d%% of %d",
        (100 * fn.line(".") / fn.line("$")),
        fn.line("$")
    ) or ""
end --}}}

M.line_info = function() --{{{
    if not M.buffer_is_plugin() then
        if fn.winwidth(0) > half_winwidth then
            return string.format("Ln %d, Col %d", fn.line("."), fn.col("."))
        else
            return string.format("%d : %d", fn.line("."), fn.col("."))
        end
    else
        return ""
    end
end --}}}

M.total_lines = function() --{{{
    return not M.buffer_is_plugin() and string.format("%d ", fn.line("$")) or ""
end --}}}

M.lsp_client_names = function() --{{{
    -- Get all active clients in the buffer
    local clients = vim.lsp.buf_get_clients()
    local client_names = {}

    -- Return csv of all clients current window width > half window width
    if fn.winwidth(0) > half_winwidth then
        for _, client in pairs(clients) do
            table.insert(client_names, client.name)
        end
        return table.concat(client_names, ", ")
    else
        -- Return "main" client
        for _, client in pairs(clients) do
            if #clients == 1 then
                return client.name
            else
                if client.name ~= "null-ls" then
                    return client.name
                end
            end
        end
    end
end --}}}

M.lsp_status = function() --{{{
    -- https://github.com/samrath2007/kyoto.nvim/blob/main/lua/plugins/statusline.lua
    local lsp_status = vim.lsp.util.get_progress_messages()[1]
    local client_names = M.lsp_client_names()

    -- Show client if client has been loaded
    if not lsp_status then
        return not M.buffer_is_plugin() and client_names or ""
    end

    -- Show client status
    local status = (lsp_status.percentage and (lsp_status.percentage .. "%% ") or lsp_status.message)
        .. lsp_status.title
    return not M.buffer_is_plugin() and status or ""
end --}}}

M.mixed_indent = function() --{{{
    local space_indent = vim.fn.search([[\v^ +]], "nw") > 0
    local tab_indent = vim.fn.search([[\v^\t+]], "nw") > 0
    local mixed = (space_indent and tab_indent) or vim.fn.search([[\v^(\t+ | +\t)]], "nw") > 0
    return mixed and "" or ""
end --}}}

M.theme_transparent = function() --{{{
    local colors = {
        darkgray = "#1d1f21",
        gray = "#3f4b59",
        innerbg = nil,
        outerbg = nil,
        outerfg = "#14191f",
        normal = "#4f9cfe",
        insert = "#a9b665",
        visual = "#e78a4e",
        replace = "#ea6962",
        command = "#d8a657",
    }
    return {
        inactive = {
            a = { fg = colors.gray, bg = colors.outerbg, gui = "bold" },
            b = { fg = colors.gray, bg = colors.outerfg },
            c = { fg = colors.gray, bg = colors.innerbg },
        },
        visual = {
            a = { fg = colors.darkgray, bg = colors.visual, gui = "bold" },
            b = { fg = colors.gray, bg = colors.outerfg },
            c = { fg = colors.gray, bg = colors.innerbg },
        },
        replace = {
            a = { fg = colors.darkgray, bg = colors.replace, gui = "bold" },
            b = { fg = colors.gray, bg = colors.outerfg },
            c = { fg = colors.gray, bg = colors.innerbg },
        },
        normal = {
            a = { fg = colors.darkgray, bg = colors.normal, gui = "bold" },
            b = { fg = colors.gray, bg = colors.outerfg },
            c = { fg = colors.gray, bg = colors.innerbg },
        },
        insert = {
            a = { fg = colors.darkgray, bg = colors.insert, gui = "bold" },
            b = { fg = colors.gray, bg = colors.outerfg },
            c = { fg = colors.gray, bg = colors.innerbg },
        },
        command = {
            a = { fg = colors.darkgray, bg = colors.command, gui = "bold" },
            b = { fg = colors.gray, bg = colors.outerfg },
            c = { fg = colors.gray, bg = colors.innerbg },
        },
    }
end --}}}

return M
