local M = {}

local fn = vim.fn
local half_winwidth = 91
local max_file_name_width = 12

M.buffer_is_plugin = function() --{{{
    local file_name = fn.expand("%:t")
    for _, v in pairs(PLUGINS) do
        if file_name == v or vim.bo.filetype == v then
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
    local file_name = fn.expand("%:t")
    local file_type = fn.expand("%:e")

    -- Truncate file_name if too big
    -- Set file name to [No Name] on empty buffers
    if file_name == "" then
        file_name = "[No Name]"
    elseif #file_name > max_file_name_width then
        file_name = string.sub(file_name, 1, max_file_name_width) .. "…"
    end

    -- Empty file_name for plugin releated buffers
    for _, v in pairs(PLUGINS) do
        if v == vim.bo.filetype then
            file_name = "…"
        end
    end

    return M.readonly() .. M.file_icon(file_name, file_type)
end --}}}

M.readonly = function() --{{{
    return (vim.bo.readonly or not vim.bo.modifiable) and " " or ""
end --}}}

M.current_mode = function() --{{{
    -- Get current mode
    local mode = require("lualine.utils.mode").get_mode()

    -- Return mode if in command mode
    if fn.mode() == "c" then
        return mode
    end

    -- Return plugin name
    local file_name = fn.expand("%:t")
    for _, v in pairs(PLUGINS) do
        if vim.bo.filetype == v or file_name == v then
            return string.upper(v)
        end
    end

    -- Return mode
    return mode
end --}}}

M.paste = function() --{{{
    return vim.o.paste and "" or ""
end --}}}

M.wrap = function() --{{{
    return vim.o.wrap and "﬋" or ""
end --}}}

M.spell = function() --{{{
    return vim.wo.spell and vim.bo.spelllang or ""
end --}}}

M.file_format = function() --{{{
    if not M.buffer_is_plugin() and fn.winwidth(0) > half_winwidth then
        return ""
    else
        return vim.bo.fileformat == "dos" and "" or vim.bo.fileformat
    end
end --}}}

M.file_encoding = function() --{{{
    if not M.buffer_is_plugin() and fn.winwidth(0) > half_winwidth then
        return ""
    else
        return vim.bo.fileencoding == "utf-8" and "" or vim.bo.fileencoding
    end
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
    local get_sources = function()
        local _, null_ls = pcall(require, "null-ls.sources")
        local sources = null_ls.get_available(vim.bo.filetype)
        local names = {}

        for _, source in pairs(sources) do
            table.insert(names, source.name)
        end

        return names
    end

    -- Get all active clients in the buffer
    local clients = vim.lsp.buf_get_clients(0)
    local client_names = {}

    if fn.winwidth(0) > half_winwidth then
        for _, client in pairs(clients) do
            if client.name ~= "null-ls" then
                table.insert(client_names, client.name)
            else
                vim.list_extend(client_names, get_sources())
            end
        end
    else
        for _, client in pairs(clients) do
            table.insert(client_names, client.name)
        end
    end

    return client_names
end --}}}

M.lsp_status = function() --{{{
    local get_lsp_status = function(client_names)
        local progress = vim.lsp.util.get_progress_messages()
        -- Get lsp status for current buffer
        for _, v in ipairs(progress) do
            -- if client_names:find(v.name) ~= nil or v.name == "null-ls" then
            if vim.tbl_contains(client_names, v.name) or v.name == "null-ls" then
                return v
            end
        end
    end

    if M.buffer_is_plugin() then
        return ""
    end

    local client_names = M.lsp_client_names()
    local lsp_status = get_lsp_status(client_names)

    -- Show client status
    if not lsp_status then
        return ""
    else
        return lsp_status.title:gsub("^%l", string.upper)
            .. " ["
            .. (lsp_status.percentage and (lsp_status.percentage .. "%%") or lsp_status.message:gsub(
                "^%l",
                string.upper
            ))
            .. "]"
    end
end --}}}

M.lsp = function() --{{{
    local clients = table.concat(M.lsp_client_names(), ", ")
    local status = M.lsp_status()

    if M.buffer_is_plugin() then
        return ""
    end

    return status ~= "" and status or clients
end --}}}

M.mixed_indent = function() --{{{
    local space_indent = vim.fn.search([[\v^ +]], "nw") > 0
    local tab_indent = vim.fn.search([[\v^\t+]], "nw") > 0
    local mixed = (space_indent and tab_indent) or vim.fn.search([[\v^(\t+ | +\t)]], "nw") > 0
    return mixed and "" or ""
end --}}}

M.theme = function() --{{{
    local scheme_colors = require("themer.modules.core.api").get_cp(SCHEME)
    local lighten = require("themer.utils.colors").lighten

    local colors = {
        bybg = lighten(scheme_colors.bg.base, 0.9, "#4C4C4C"),
        cxbg = "None",

        lightgray = lighten(scheme_colors.fg, 0.5, scheme_colors.bg.base),
        darkgray = scheme_colors.bg.base,

        -- modes
        normal = scheme_colors.blue,
        insert = scheme_colors.green,
        visual = scheme_colors.orange,
        replace = scheme_colors.red,
        command = scheme_colors.yellow,
    }

    return {
        inactive = {
            a = { fg = colors.lightgray, bg = colors.bybg, gui = "bold" },
            b = { fg = colors.lightgray, bg = colors.bybg, gui = "bold" },
            c = { fg = colors.lightgray, bg = colors.cxbg, gui = "bold" },
        },
        visual = {
            a = { fg = colors.darkgray, bg = colors.visual, gui = "bold" },
            b = { fg = colors.lightgray, bg = colors.bybg, gui = "bold" },
            c = { fg = colors.lightgray, bg = colors.cxbg, gui = "bold" },
        },
        replace = {
            a = { fg = colors.darkgray, bg = colors.replace, gui = "bold" },
            b = { fg = colors.lightgray, bg = colors.bybg, gui = "bold" },
            c = { fg = colors.lightgray, bg = colors.cxbg, gui = "bold" },
        },
        normal = {
            a = { fg = colors.darkgray, bg = colors.normal, gui = "bold" },
            b = { fg = colors.lightgray, bg = colors.bybg, gui = "bold" },
            c = { fg = colors.lightgray, bg = colors.cxbg, gui = "bold" },
        },
        insert = {
            a = { fg = colors.darkgray, bg = colors.insert, gui = "bold" },
            b = { fg = colors.lightgray, bg = colors.bybg, gui = "bold" },
            c = { fg = colors.lightgray, bg = colors.cxbg, gui = "bold" },
        },
        command = {
            a = { fg = colors.darkgray, bg = colors.command, gui = "bold" },
            b = { fg = colors.lightgray, bg = colors.bybg, gui = "bold" },
            c = { fg = colors.lightgray, bg = colors.cxbg, gui = "bold" },
        },
    }
end --}}}

M.compile_status = function() --{{{
    if vim.bo.filetype == "tex" then
        -- Status: not started or stopped
        if vim.b.vimtex["compiler"]["status"] == -1 or vim.b.vimtex["compiler"]["status"] == 0 then
            return ""
        end

        -- Status: running
        if vim.b.vimtex["compiler"]["status"] == 1 then
            return "(⋯)"
            -- Status: compile success
        elseif vim.b.vimtex["compiler"]["status"] == 2 then
            return "()"
            -- Status: compile failed
        elseif vim.b.vimtex["compiler"]["status"] == 3 then
            return "()"
        end
    else
        return ""
    end
end --}}}

return M
