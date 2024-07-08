local present, themer_api = pcall(require, "themer.modules.core.api")
if not present then
    return
end

local colors = themer_api.get_cp(SCHEME)

local M = {}

M.icons = {
    powerline = {
        -- 
        vertical_bar_thin = "│",
        vertical_bar = "┃",
        block = "█",
        ----------------------------------------------
        left = "",
        left_filled = "",
        right = "",
        right_filled = "",
        ----------------------------------------------
        slant_left = "",
        slant_left_thin = "",
        slant_right = "",
        slant_right_thin = "",
        ----------------------------------------------
        slant_left_2 = "",
        slant_left_2_thin = "",
        slant_right_2 = "",
        slant_right_2_thin = "",
        ----------------------------------------------
        left_rounded = "",
        left_rounded_thin = "",
        right_rounded = "",
        right_rounded_thin = "",
        ----------------------------------------------
        trapezoid_left = "",
        trapezoid_right = "",
        ----------------------------------------------
        line_number = "",
        column_number = "",
    },
    vim = "",
    padlock = "",
    git_branch = "",
    paste = "",
    wrap = "﬋",
    mixed_indents = "",
    terminal = "",
    circle = "",
    circle_plus = "",
    dot_circle_o = "",
    circle_o = "⭘",
    search = "",
    total_lines = "",
    path_sep = "",
}

M.mode_names = {
    ["n"] = "NORMAL",
    ["no"] = "O-PENDING",
    ["nov"] = "O-PENDING",
    ["noV"] = "O-PENDING",
    ["no\22"] = "O-PENDING",
    ["niI"] = "NORMAL",
    ["niR"] = "NORMAL",
    ["niV"] = "NORMAL",
    ["nt"] = "NORMAL",
    ["v"] = "VISUAL",
    ["vs"] = "VISUAL",
    ["V"] = "V-LINE",
    ["Vs"] = "V-LINE",
    ["\22"] = "V-BLOCK",
    ["\22s"] = "V-BLOCK",
    ["s"] = "SELECT",
    ["S"] = "S-LINE",
    ["\19"] = "S-BLOCK",
    ["i"] = "INSERT",
    ["ic"] = "INSERT",
    ["ix"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rc"] = "REPLACE",
    ["Rx"] = "REPLACE",
    ["Rv"] = "V-REPLACE",
    ["Rvc"] = "V-REPLACE",
    ["Rvx"] = "V-REPLACE",
    ["c"] = "COMMAND",
    ["cv"] = "EX",
    ["ce"] = "EX",
    ["r"] = "REPLACE",
    ["rm"] = "MORE",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["t"] = "TERMINAL",
    ["V-M"] = "V-MULTI",
}

M.mode_colors = {
    n = colors.blue,
    i = colors.green,
    v = colors.orange,
    V = colors.orange,
    ["\22"] = colors.orange,
    c = colors.yellow,
    s = colors.purple,
    S = colors.purple,
    ["\19"] = colors.purple,
    R = colors.red,
    r = colors.red,
    ["!"] = colors.cyan,
    t = colors.cyan,
}

M.buffer_is_plugin = function()
    local file_name = vim.fn.expand("%:t")
    for _, v in pairs(PLUGINS) do
        if file_name == v or vim.bo.filetype == v then
            return true
        end
    end
end

M.lsp_client_names = function(shorten)
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
    local clients = vim.lsp.get_clients()
    local client_names = {}

    if not shorten then
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
end

M.lsp_status = function()
    local get_lsp_status = function(client_names)
        local progress = vim.lsp.status()
        -- Get lsp status for current buffer
        for _, v in ipairs(progress) do
            if vim.tbl_contains(client_names, v.name) or v.name == "null-ls" then
                return v
            end
        end
    end

    local client_names = M.lsp_client_names()
    local lsp_status = get_lsp_status(client_names)

    -- Show client status
    if lsp_status and lsp_status.message then
        return lsp_status.title:gsub("^%l", string.upper)
            .. " ["
            .. (lsp_status.percentage and (lsp_status.percentage .. "%%") or lsp_status.message:gsub(
                "^%l",
                string.upper
            ))
            .. "]"
    end
end

M.replace_pathsep = function(path)
    return path:gsub("/", "\\"):gsub("\\", (" %s "):format(M.icons.path_sep))
end

return M
