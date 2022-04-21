-- Telescope utilities
local M = {}

-- Custom dropdown theme
M.dropdown = function(opts) --{{{
    opts = opts or {}

    local theme_opts = {
        theme = "dropdown",

        previewer = false,
        results_title = false,

        sorting_strategy = "ascending",
        layout_strategy = "center",

        layout_config = {
            width = function(_, max_columns, _)
                return math.min(max_columns - 10, 100)
            end,

            height = function(_, _, max_lines)
                return math.min(max_lines, 20)
            end,
        },

        border = true,
        borderchars = {
            { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
            prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
            results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
            preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        },
    }

    return vim.tbl_deep_extend("force", theme_opts, opts)
end --}}}

-- Only list files with extensions in the whitelist
M.file_sorter = function(whitelist) --{{{
    local sorter = require("telescope.sorters").get_fuzzy_file()

    sorter._was_discarded = function()
        return false
    end

    -- Filter based on whitelist
    sorter.filter_function = function(_, prompt, entry)
        for _, v in ipairs(whitelist) do
            if entry.value:find(v) then
                -- 0 is highest filtering score
                return 0, prompt
            end
        end
        -- -1 is considered filtered
        return -1, prompt
    end

    return sorter
end --}}}

return M
