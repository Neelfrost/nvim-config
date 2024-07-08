local present, _ = pcall(require, "themer.modules.core.api")
if not present then
    return
end

-- Themer colors
local themer = require("user.plugins.config.themer")
local colors = themer.colors

-- Helpers
local helper = require("user.plugins.config.heirline.utils")
local theme = require("user.plugins.config.heirline.theme")
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local M = {}

local function mode()
    return M.visual_multi.condition() and "V-M" or vim.api.nvim_get_mode().mode
end

M.align = {
    provider = "%=",
    hl = function()
        return { fg = helper.mode_colors[vim.api.nvim_get_mode().mode:sub(1, 1)], bold = true }
    end,
}
M.null = { provider = "" }
M.space = setmetatable({
    provider = " ",
}, {
    __call = function(_, condition)
        return {
            provider = " ",
            condition = condition,
        }
    end,
})

M.delim_left = function(icon, hl)
    return {
        {
            provider = helper.icons.powerline[icon],
            hl = hl,
        },
        M.space,
    }
end
M.delim_right = function(icon, hl)
    return {
        M.space,
        {
            provider = helper.icons.powerline[icon],
            hl = hl,
        },
    }
end

M.vim_icon = {
    provider = helper.icons.vim,
    hl = { fg = theme.vim },
}

M.vim_mode = {}

M.vim_mode = utils.insert(M.vim_mode, M.space, M.vim_icon, M.space, {
    init = function(self)
        self.mode = mode()
    end,

    {
        flexible = 8,
        {
            provider = function(self)
                return helper.mode_names[self.mode]
            end,
        },
        {
            provider = function(self)
                return helper.mode_names[self.mode]:sub(1, 1)
            end,
        },
    },

    hl = function(self)
        return { bg = theme.bg1, fg = helper.mode_colors[self.mode:sub(1, 1)], bold = true }
    end,
}, M.space)

M.vim_mode = utils.surround({ "", helper.icons.powerline.slant_right }, function()
    return theme.bg1
end, M.vim_mode)

M.git_info = {
    condition = conditions.is_git_repo,

    init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.added = self.status_dict.added and self.status_dict.added ~= 0
        self.removed = self.status_dict.removed and self.status_dict.removed ~= 0
        self.changed = self.status_dict.changed and self.status_dict.changed ~= 0
        self.has_changes = self.added or self.removed or self.changed
    end,

    M.delim_left("slant_left_2", theme.surround),
    {
        provider = function()
            return helper.icons.git_branch .. " "
        end,
        hl = { fg = colors.magenta },
    },
    {
        provider = function(self)
            return self.status_dict.head
        end,
    },
    {
        flexible = 6,
        {
            {
                condition = function(self)
                    return self.has_changes
                end,
                provider = " (",
            },
            {
                provider = function(self)
                    local count = self.status_dict.added or 0
                    return count > 0 and ("+" .. count)
                end,
                hl = { fg = colors.green },
            },
            M.space(function(self)
                return self.added and (self.removed or self.changed)
            end),
            {
                provider = function(self)
                    local count = self.status_dict.removed or 0
                    return count > 0 and ("-" .. count)
                end,
                hl = { fg = colors.red },
            },
            M.space(function(self)
                return self.removed and self.changed
            end),
            {
                provider = function(self)
                    local count = self.status_dict.changed or 0
                    return count > 0 and ("~" .. count)
                end,
                hl = { fg = colors.yellow },
            },
            {
                condition = function(self)
                    return self.has_changes
                end,
                provider = ")",
            },
        },
        M.null,
    },
    M.delim_right("slant_right", theme.surround),

    hl = theme.component,
}

M.file_block = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
    end,

    hl = theme.component,
}

M.readonly = {
    condition = function()
        return vim.bo.readonly or not vim.bo.modifiable
    end,

    provider = helper.icons.padlock .. " ",

    hl = { fg = colors.red, bold = true },
}

M.file_icon = {
    init = function(self)
        self.filetype = vim.fn.fnamemodify(self.filename, ":e")
        self.icon, self.icon_color =
            require("nvim-web-devicons").get_icon_color(self.filename, self.filetype, { default = true })
    end,

    provider = function(self)
        return self.filetype ~= "" and (self.icon .. " ")
    end,

    hl = function(self)
        return { fg = self.icon_color }
    end,
}

M.file_name = {
    provider = function(self)
        local _filename = vim.fn.fnamemodify(self.filename, ":t")

        -- Truncate file_name if too big
        -- Set file name to [No Name] on empty buffers
        if _filename == "" then
            _filename = "[No Name]"
        end

        if not conditions.width_percent_below(#_filename, 0.25) then
            _filename = string.sub(_filename, 1, 12) .. "…" .. self.filetype
        end

        -- Empty file_name for plugin releated buffers
        for _, v in pairs(PLUGINS) do
            if v == vim.bo.filetype then
                _filename = "…"
            end
        end

        return _filename
    end,

    hl = theme.component,
}

M.vimtex_compile_status = {
    condition = function()
        return vim.bo.filetype == "tex"
    end,

    init = function(self)
        if vim.b.vimtex then
            self.status = vim.b.vimtex["compiler"]["status"]
        end
    end,

    provider = function(self)
        -- Status: running
        if self.status == 1 then
            return " (⋯)"
            -- Status: compile success
        elseif self.status == 2 then
            return " ()"
            -- Status: compile failed
        elseif self.status == 3 then
            return " ()"
        end
    end,

    hl = function(self)
        if self.status == 1 then
            return { fg = colors.blue }
        elseif self.status == 2 then
            return { fg = colors.green }
        elseif self.status == 3 then
            return { fg = colors.red }
        end
    end,
}

M.file_block = utils.insert(
    M.file_block,
    M.space,
    M.readonly,
    utils.insert(M.file_icon, M.file_name, M.vimtex_compile_status),
    M.space
)

M.file_block =
    utils.surround({ helper.icons.powerline.slant_left_2, helper.icons.powerline.slant_right }, theme.bg1, M.file_block)

M.search_results = {
    condition = function(self)
        if vim.api.nvim_buf_line_count(0) > 50000 or M.visual_multi.condition() then
            return
        end

        local query = vim.fn.getreg("/")
        if query == "" or query:find("@") then
            return
        end

        local active = false
        local search_count = vim.fn.searchcount({ recompute = 1, maxcount = -1 })

        if vim.v.hlsearch and vim.v.hlsearch == 1 and search_count.total > 0 then
            active = true
        end

        if not active then
            return
        end

        self.count = search_count

        return true
    end,

    M.delim_left("slant_left_2", theme.surround),
    {
        provider = helper.icons.search .. " ",
        hl = { fg = colors.yellow },
    },
    {
        provider = function(self)
            return table.concat({ self.count.current, "/", self.count.total })
        end,
    },
    M.delim_right("slant_right", theme.surround),

    hl = theme.component,
}

M.visual_multi = {
    condition = function()
        return exists_and_not_nil(vim.b.VM_Selection)
    end,

    init = function(self)
        local info = vim.fn.VMInfos()
        self.patterns = exists_and_not_nil(info.patterns)
                and string.format("(%s)", table.concat(info.patterns, ", "):gsub("[\\<>]", ""))
            or ""
        self.ratio = info.ratio and info.ratio:gsub(" ", "") or ""
        self.status = info.status or ""
    end,

    M.delim_left("slant_left_2", theme.surround),
    {
        provider = helper.icons.search,
        hl = { fg = colors.yellow },
    },
    M.space,
    {
        provider = function(self)
            return self.patterns
        end,
    },
    M.space(function(self)
        return self.patterns ~= "" and self.ratio ~= ""
    end),
    {
        provider = function(self)
            return self.ratio
        end,
    },
    M.space(function(self)
        return self.ratio ~= "" and self.status ~= ""
    end),
    {
        provider = function(self)
            return self.status
        end,
    },
    M.delim_right("slant_right", theme.surround),

    hl = theme.component,
}

M.spellcheck = {
    condition = function()
        return vim.wo.spell
    end,

    M.delim_left("slant_left_2", theme.surround),
    { provider = vim.bo.spelllang },
    M.delim_right("slant_right", theme.surround),

    hl = theme.component,
}

M.file_format = {
    init = function(self)
        self.fileformat = vim.bo.fileformat
        if self.fileformat == "dos" then
            self.text = "CRLF"
        elseif self.fileformat == "unix" then
            self.text = "LF"
        else
            self.text = "CR"
        end
    end,

    condition = function(self)
        return self.fileformat ~= "dos"
    end,

    M.delim_left("slant_left_2", theme.surround),
    {
        provider = function(self)
            return self.text
        end,
    },
    M.delim_right("slant_right", theme.surround),

    hl = theme.component,
}

M.file_encoding = {
    condition = function()
        return vim.bo.fileencoding ~= "utf-8"
    end,

    M.delim_left("slant_left_2", theme.surround),
    { provider = vim.bo.fileencoding:upper() },
    M.delim_right("slant_right", theme.surround),

    hl = theme.component,
}

M.paste = {
    condition = function()
        return vim.o.paste
    end,

    M.delim_left("slant_left", theme.surround),
    { provider = helper.icons.paste },
    M.delim_right("slant_right_2", theme.surround),

    hl = theme.component,
}

M.wrap = {
    condition = function()
        return vim.o.wrap
    end,

    M.delim_left("slant_left", theme.surround),
    { provider = helper.icons.wrap },
    M.delim_right("slant_right_2", theme.surround),

    hl = theme.component,
}

M.mixed_indents = {
    condition = function()
        local space_indent = vim.fn.search([[\v^ +]], "nw") > 0
        local tab_indent = vim.fn.search([[\v^\t+]], "nw") > 0
        return (space_indent and tab_indent) or vim.fn.search([[\v^(\t+ | +\t)]], "nw") > 0
    end,

    M.delim_left("slant_left", theme.surround),
    { provider = helper.icons.mixed_indents },
    M.delim_right("slant_right_2", theme.surround),

    hl = theme.component,
}

M.lsp_info = {
    condition = conditions.lsp_attached,

    init = function(self)
        self.clients = table.concat(helper.lsp_client_names(), ", ")
        self.short_clients = table.concat(helper.lsp_client_names(true), ", ")
        -- self.status = helper.lsp_status()
    end,

    {
        flexible = 3,
        {
            M.delim_left("slant_left", theme.surround),
            {
                provider = function(self)
                    return self.status ~= "" and self.status or self.clients
                end,
            },
            M.delim_right("slant_right_2", theme.surround),
        },
        {
            M.delim_left("slant_left", theme.surround),
            {
                provider = function(self)
                    return self.short_clients
                end,
            },
            M.delim_right("slant_right_2", theme.surround),
        },
        M.null,
    },

    hl = theme.component,
}

M.line_info = {
    init = function(self)
        self.line = vim.fn.line(".")
        self.column = vim.fn.col(".")
    end,

    M.delim_left("slant_left", theme.surround),
    {
        flexible = 4,
        {
            provider = function(self)
                return string.format("Ln %d, Col %d", self.line, self.column)
            end,
        },
        {
            provider = function(self)
                return string.format("%d : %d", self.line, self.column)
            end,
        },
    },
    M.delim_right("slant_right_2", theme.surround),

    hl = theme.component,
}

M.total_lines = {
    init = function(self)
        self.lines = vim.fn.line("$")
    end,

    provider = function(self)
        return string.format(" %d %s ", self.lines, helper.icons.total_lines)
    end,

    hl = function()
        return {
            fg = helper.mode_colors[mode():sub(1, 1)],
            bg = theme.bg1,
            bold = true,
        }
    end,
}

M.total_lines = utils.surround({ helper.icons.powerline.slant_left, "" }, function()
    return theme.bg1
end, M.total_lines)

M.terminal_name = {}

M.terminal_name = utils.insert(
    M.terminal_name,
    M.space,
    { provider = helper.icons.terminal, hl = { fg = colors.blue, bold = true } },
    M.space,
    {
        provider = function()
            local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
            return tname
        end,

        hl = function()
            return { bg = theme.bg1, fg = helper.mode_colors[vim.api.nvim_get_mode().mode:sub(1, 1)], bold = true }
        end,
    },
    M.space
)

M.terminal_name = utils.surround({ helper.icons.powerline.slant_left, "" }, function()
    return theme.bg1
end, M.terminal_name)

M.winbar = {
    fallthrough = false,
    {
        condition = function()
            return conditions.buffer_matches({
                buftype = { "terminal", "nofile", "prompt", "help", "quickfix" },
                filetype = { "^git.*", "fugitive" },
            })
        end,
        init = function()
            vim.opt_local.winbar = nil
        end,
    },
    {
        init = function(self)
            self.file_path = vim.api.nvim_buf_get_name(0):gsub("^%l", string.upper)
            self.is_git_repo = conditions.is_git_repo()
        end,

        provider = function(self)
            return self.is_git_repo
                    and string.rep(" ", 4) .. helper.replace_pathsep(
                        helper.icons.git_branch
                            .. "\\"
                            .. self.file_path:gsub(vim.b.gitsigns_status_dict.root:gsub("/", "\\") .. "\\", "")
                    )
                or string.rep(" ", 4) .. helper.replace_pathsep(self.file_path)
        end,
    },
    hl = theme.winbar,
}

return M
