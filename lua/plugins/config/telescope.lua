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

-- Find files in custom dirs
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

-- Reloading lua modules using Telescope
-- taken and modified from:
-- https://ustrajunior.com/posts/reloading-neovim-config-with-telescope/
M.reload_modules = function() --{{{
	-- set the path to the lua folder
	local path = CONFIG_PATH .. "\\lua\\"

	-- Telescope will give us something like ju/colors.lua,
	-- so this function convert the selected entry to
	-- the module name: ju.colors
	local function get_module_name(s)
		local module_name
		module_name = s:gsub(path, "")
		module_name = module_name:gsub("%.lua", "")
		module_name = module_name:gsub("\\", ".")
		module_name = module_name:gsub("%.init", "")
		return module_name
	end

	local opts = {
		cwd = path,
		prompt_title = "Reload Neovim Modules",
		attach_mappings = function(prompt_bufnr, map)
			-- Reload module and close prompt
			require("telescope.actions.set").select:replace(function(prompt_bufnr, type)
				local entry = require("telescope.actions.state").get_selected_entry()
				require("telescope.actions").close(prompt_bufnr)
				local name = get_module_name(entry.value)
				-- call the helper method to reload the module
				plenary_reload(name)
				-- and give some feedback
				verbose_print(name .. " Reloaded.")
			end)
			-- Map <C-e> to reload module
			map("i", "<C-e>", function(_)
				local entry = require("telescope.actions.state").get_selected_entry()
				local name = get_module_name(entry.value)
				-- call the helper method to reload the module
				plenary_reload(name)
				-- and give some feedback
				verbose_print(name .. " Reloaded.")
			end)

			return true
		end,
	}

	require("telescope.builtin").find_files(opts)
end --}}}

-- Session list
M.list_sessions = function() --{{{
	local function load_session(file_path)
		vim.cmd("source " .. file_path)
	end

	local function delete_sesssion(file_path)
		local session = vim.fn.fnamemodify(file_path, ":t:r")
		vim.cmd("echohl MoreMsg")
		vim.cmd(string.format('echomsg "Session" "\'%s\'" "removed"', session))
		vim.cmd("echohl None")
		vim.cmd("silent !del " .. file_path)
	end

	local opts = {
		cwd = vim.g.session_directory,
		prompt_title = "Sessions",
		attach_mappings = function(prompt_bufnr, map)
			-- This will replace select no matter on which key it is mapped by default
			require("telescope.actions.set").select:replace(function(prompt_bufnr, type)
				local entry = require("telescope.actions.state").get_selected_entry()
				require("telescope.actions").close(prompt_bufnr)
				load_session(entry.value)
			end)
			-- Map <C-e> to remove session
			map("i", "<C-e>", function(_)
				local entry = require("telescope.actions.state").get_selected_entry()
				delete_sesssion(entry.value)
			end)

			return true
		end,
	}

	require("telescope.builtin").find_files(opts)
end --}}}

-- Frecency
M.frecency = function() --{{{
	local frecency_opts = M.dropdown({ prompt_title = "Recent Files" })
	require("telescope").extensions.frecency.frecency(frecency_opts)
end --}}}

return M
