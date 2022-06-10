local colors = require("themer.modules.core.api").get_cp(SCHEME)
local helper = require("user.plugins.config.heirline.utils")
local theme = require("user.plugins.config.heirline.theme")
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local M = {}

M.align = { provider = "%=" }
M.space = { provider = " " }
M.null = { provider = "" }

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
        self.mode = vim.api.nvim_get_mode().mode
    end,

    utils.make_flexible_component(8, {
        provider = function(self)
            return helper.mode_names[self.mode]
        end,
    }, {
        provider = function(self)
            return helper.mode_names[self.mode]:sub(1, 1)
        end,
    }),

    hl = function()
        return { bg = theme.bg1, fg = helper.mode_colors[vim.api.nvim_get_mode().mode:sub(1, 1)], bold = true }
    end,
}, M.space)

M.vim_mode = utils.surround({ "", helper.icons.powerline.slant_right }, function()
    return theme.bg1
end, M.vim_mode)

M.git_info = {
    condition = conditions.is_git_repo,

    init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = (self.status_dict.added or self.status_dict.removed or self.status_dict.changed)
            and (self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0)
    end,

    M.delim_left("slant_left_2", theme.bi),
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
    utils.make_flexible_component(6, {
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
        {
            provider = function(self)
                return (
                        self.status_dict.added ~= 0
                        and (self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0)
                    ) and " "
            end,
        },
        {
            provider = function(self)
                local count = self.status_dict.removed or 0
                return count > 0 and ("-" .. count)
            end,
            hl = { fg = colors.red },
        },
        {
            provider = function(self)
                return (self.status_dict.removed ~= 0 and self.status_dict.changed ~= 0) and " "
            end,
        },
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
    }, M.null),
    M.delim_right("slant_right", theme.bi),

    hl = theme.b,
}

M.file_block = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
    end,

    hl = theme.b,
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
        self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(
            self.filename,
            self.filetype,
            { default = true }
        )
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

    hl = theme.b,
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

M.file_block = utils.surround(
    { helper.icons.powerline.slant_left_2, helper.icons.powerline.slant_right },
    theme.bg2,
    M.file_block
)

M.spellcheck = {
    condition = function()
        return vim.wo.spell
    end,

    M.delim_left("slant_left_2", theme.ci),
    { provider = vim.bo.spelllang },
    M.delim_right("slant_right", theme.ci),

    hl = theme.c,
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

    M.delim_left("slant_left_2", theme.ci),
    {
        provider = function(self)
            return self.text
        end,
    },
    M.delim_right("slant_right", theme.ci),

    hl = theme.c,
}

M.file_encoding = {
    condition = function()
        return vim.bo.fileencoding ~= "utf-8"
    end,

    M.delim_left("slant_left_2", theme.ci),
    { provider = vim.bo.fileencoding:upper() },
    M.delim_right("slant_right", theme.ci),

    hl = theme.c,
}

M.paste = {
    condition = function()
        return vim.o.paste
    end,

    M.delim_left("slant_left", theme.ci),
    { provider = helper.icons.paste },
    M.delim_right("slant_right_2", theme.ci),

    hl = theme.c,
}

M.wrap = {
    condition = function()
        return vim.o.wrap
    end,

    M.delim_left("slant_left", theme.ci),
    { provider = helper.icons.wrap },
    M.delim_right("slant_right_2", theme.ci),

    hl = theme.c,
}

M.mixed_indents = {
    condition = function()
        local space_indent = vim.fn.search([[\v^ +]], "nw") > 0
        local tab_indent = vim.fn.search([[\v^\t+]], "nw") > 0
        return (space_indent and tab_indent) or vim.fn.search([[\v^(\t+ | +\t)]], "nw") > 0
    end,

    M.delim_left("slant_left", theme.ci),
    { provider = helper.icons.mixed_indents },
    M.delim_right("slant_right_2", theme.ci),

    hl = theme.c,
}

M.lsp_info = {
    condition = conditions.lsp_attached,

    init = function(self)
        self.clients = table.concat(helper.lsp_client_names(), ", ")
        self.short_clients = table.concat(helper.lsp_client_names(true), ", ")
        self.status = helper.lsp_status()
    end,

    utils.make_flexible_component(3, {
        M.delim_left("slant_left", theme.bi),
        {
            provider = function(self)
                return self.status ~= "" and self.status or self.clients
            end,
        },
        M.delim_right("slant_right_2", theme.bi),
    }, {
        M.delim_left("slant_left", theme.bi),
        {
            provider = function(self)
                return self.short_clients
            end,
        },
        M.delim_right("slant_right_2", theme.bi),
    }, M.null),

    hl = theme.b,
}

M.line_info = {
    init = function(self)
        self.line = vim.fn.line(".")
        self.column = vim.fn.col(".")
    end,

    M.delim_left("slant_left", theme.bi),
    utils.make_flexible_component(4, {
        provider = function(self)
            return string.format("Ln %d, Col %d", self.line, self.column)
        end,
    }, {
        provider = function(self)
            return string.format("%d : %d", self.line, self.column)
        end,
    }),
    M.delim_right("slant_right_2", theme.bi),

    hl = theme.b,
}

M.total_lines = {
    init = function(self)
        self.lines = vim.fn.line("$")
    end,

    provider = function(self)
        return string.format(" %d  ", self.lines)
    end,

    hl = function()
        return { bg = theme.bg1, fg = helper.mode_colors[vim.api.nvim_get_mode().mode:sub(1, 1)], bold = true }
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

return M

