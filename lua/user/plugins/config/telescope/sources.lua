local utils = require("user.plugins.config.telescope.utils")
local file_sorter = utils.file_sorter
local dropdown = utils.dropdown

-- Custom telescope pickers
local M = {}

-- List files in specified directories with pre-filtering
M.dir_nvim = function()
    local opts = {
        cwd = CONFIG_PATH,
        prompt_title = "Neovim",
        no_ignore = true,
    }
    require("telescope.builtin").find_files(opts)
end

M.dir_plugins = function()
    local opts = {
        cwd = LAZY_PATH,
        file_ignore_patterns = vim.list_extend({ "test\\" }, utils.ignore_patterns),
        prompt_title = "Plugin Files",
    }
    require("telescope.builtin").find_files(opts)
end

-- Reload lua modules using Telescope
-- taken and modified from:
-- https://ustrajunior.com/posts/reloading-neovim-config-with-telescope/
M.reload_modules = function()
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
                -- Remove leading ".\"
                local name = get_module_name(cwd .. entry.value:gsub("^%.\\", ""))

                if should_close then
                    require("telescope.actions").close(prompt_bufnr)
                end

                -- Reload filename
                plenary_reload(name)
                -- Print filename
                vim_notify(("%s Reloaded."):format(name), vim.log.levels.INFO)
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
end

-- Use dropdown theme with Frecency
M.frecency = function()
    local frecency_opts = dropdown({ prompt_title = "Recent Files", path_display = { "absolute" } })
    require("telescope").extensions.frecency.frecency(frecency_opts)
end

-- Fall back to find_files if not a git directory
M.git_or_find = function()
    local opts = dropdown({ prompt_title = "Find Files" })
    local ok = pcall(require("telescope.builtin").git_files, opts)
    if not ok then
        require("telescope.builtin").find_files(opts)
    end
end

return M
