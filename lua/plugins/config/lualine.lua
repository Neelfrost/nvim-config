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

    return M.readonly() .. M.file_icon(file_name, file_type) .. M.compile_status()
end --}}}

M.readonly = function() --{{{
    return (vim.bo.readonly or not vim.bo.modifiable) and " " or ""
end --}}}

M.current_mode = function() --{{{
    -- Get current mode
    local mode = require("lualine.utils.mode").get_mode()

    -- Plugin name to be shown in mode section
    local mode_plugins = {
        NvimTree = "NVIMTREE",
        packer = "PACKER",
        alpha = "ALPHA",
    }

    -- Return mode if in command mode
    if fn.mode() == "c" then
        return mode
    end

    -- Return plugin name
    local file_name = fn.expand("%:t")
    for k, v in pairs(mode_plugins) do
        if vim.bo.filetype == k or file_name == k then
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
            elseif client.name ~= "null-ls" then
                return client.name
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

M.theme = function() --{{{
    local colors = {
        ["gruvbox-material"] = {
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
        },
        ["kanagawa"] = {
            darkgray = "#16161d",
            gray = "#727169",
            innerbg = nil,
            outerbg = nil,
            outerfg = "#16161D",
            normal = "#7e9cd8",
            insert = "#98bb6c",
            visual = "#ffa066",
            replace = "#e46876",
            command = "#e6c384",
        },
    }
    return {
        inactive = {
            a = { fg = colors[vim.g.colors_name].gray, bg = colors[vim.g.colors_name].outerbg, gui = "bold" },
            b = { fg = colors[vim.g.colors_name].gray, bg = colors[vim.g.colors_name].outerfg },
            c = { fg = colors[vim.g.colors_name].gray, bg = colors[vim.g.colors_name].innerbg },
        },
        visual = {
            a = { fg = colors[vim.g.colors_name].darkgray, bg = colors[vim.g.colors_name].visual, gui = "bold" },
            b = { fg = colors[vim.g.colors_name].gray, bg = colors[vim.g.colors_name].outerfg },
            c = { fg = colors[vim.g.colors_name].gray, bg = colors[vim.g.colors_name].innerbg },
        },
        replace = {
            a = { fg = colors[vim.g.colors_name].darkgray, bg = colors[vim.g.colors_name].replace, gui = "bold" },
            b = { fg = colors[vim.g.colors_name].gray, bg = colors[vim.g.colors_name].outerfg },
            c = { fg = colors[vim.g.colors_name].gray, bg = colors[vim.g.colors_name].innerbg },
        },
        normal = {
            a = { fg = colors[vim.g.colors_name].darkgray, bg = colors[vim.g.colors_name].normal, gui = "bold" },
            b = { fg = colors[vim.g.colors_name].gray, bg = colors[vim.g.colors_name].outerfg },
            c = { fg = colors[vim.g.colors_name].gray, bg = colors[vim.g.colors_name].innerbg },
        },
        insert = {
            a = { fg = colors[vim.g.colors_name].darkgray, bg = colors[vim.g.colors_name].insert, gui = "bold" },
            b = { fg = colors[vim.g.colors_name].gray, bg = colors[vim.g.colors_name].outerfg },
            c = { fg = colors[vim.g.colors_name].gray, bg = colors[vim.g.colors_name].innerbg },
        },
        command = {
            a = { fg = colors[vim.g.colors_name].darkgray, bg = colors[vim.g.colors_name].command, gui = "bold" },
            b = { fg = colors[vim.g.colors_name].gray, bg = colors[vim.g.colors_name].outerfg },
            c = { fg = colors[vim.g.colors_name].gray, bg = colors[vim.g.colors_name].innerbg },
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
            return " (⋯)"
            -- Status: compile success
        elseif vim.b.vimtex["compiler"]["status"] == 2 then
            return " ()"
            -- Status: compile failed
        elseif vim.b.vimtex["compiler"]["status"] == 3 then
            return " ()"
        end
    else
        return ""
    end
end --}}}

return M
