-- Custom telescope pickers
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
local file_sorter = function(whitelist) --{{{
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

-- List files in specified directories with pre-filtering
M.dir_nvim = function() --{{{
    local opts = {
        cwd = CONFIG_PATH,
        file_ignore_patterns = { ".git", "tags" },
        prompt_title = "Neovim",
    }

    require("telescope.builtin").find_files(opts)
end --}}}

M.dir_latex = function() --{{{
    local opts = {
        cwd = HOME_PATH .. "\\Documents\\LaTeX",
        file_ignore_patterns = { ".git", "tags" },
        prompt_title = "LaTeX",
        sorter = file_sorter({ "%.tex$", "%.sty$", "%.cls$" }),
    }

    require("telescope.builtin").find_files(opts)
end --}}}

M.dir_python = function() --{{{
    local opts = {
        cwd = "D:\\My Folder\\Dev\\Python",
        file_ignore_patterns = { ".git", "tags", "__pycache__", "venv", "__init__" },
        prompt_title = "Python",
        sorter = file_sorter({ "%.py$" }),
    }

    require("telescope.builtin").find_files(opts)
end --}}}

-- Reload lua modules using Telescope
-- taken and modified from:
-- https://ustrajunior.com/posts/reloading-neovim-config-with-telescope/
M.reload_modules = function() --{{{
    local actions_state = require("telescope.actions.state")
    local cwd = CONFIG_PATH .. "\\lua\\"

    local opts = {
        cwd = cwd,
        prompt_title = "Reload Neovim Modules",
        -- Only show lua files
        sorter = file_sorter({ "%.lua$" }),
        attach_mappings = function(prompt_bufnr, map)
            -- Reload module
            local reload_module_map = function(should_close)
                local entry = actions_state.get_selected_entry()
                -- Append cwd to entry value (due to smart display mode)
                local name = get_module_name(cwd .. entry.value)

                if should_close then
                    require("telescope.actions").close(prompt_bufnr)
                end

                -- Reload filename
                plenary_reload(name)
                -- Print filename
                print(name .. " Reloaded.")
            end

            -- Map <Enter> to reload module
            require("telescope.actions.set").select:replace(function()
                reload_module_map(true)
            end)
            -- Map <C-r> to reload module
            map("i", "<C-r>", function()
                reload_module_map()
            end)

            return true
        end,
    }

    require("telescope.builtin").find_files(opts)
end --}}}

-- Use dropdown theme with Frecency
M.frecency = function() --{{{
    local frecency_opts = M.dropdown({ prompt_title = "Recent Files", path_display = { "absolute" } })
    require("telescope").extensions.frecency.frecency(frecency_opts)
end --}}}

M.sessions = function()
    local session_opts = M.dropdown({ path_display = { "absolute" } })
    require("telescope").extensions.sessions.sessions(session_opts)
end

return M
