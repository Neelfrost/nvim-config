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

	local opts = {
		cwd = CONFIG_PATH .. "\\lua\\",
		prompt_title = "Reload Neovim Modules",
		attach_mappings = function(prompt_bufnr, map)
			-- Reload module
			local reload_module_map = function(should_close)
				local entry = actions_state.get_selected_entry()
				local name = get_module_name(entry.value)

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

-- Load/delete vim sessions using Telescope
M.list_sessions = function() --{{{
	local function load_session(file_path)
		vim.lsp.stop_client(vim.lsp.get_active_clients())
		vim.api.nvim_command("silent! source " .. file_path)
		vim.cmd(string.format('echomsg "Loaded" "\'%s\'" "session"', file_path:gsub("\\", "\\\\")))
	end

	local function delete_sesssion(file_path)
		local session = vim.fn.fnamemodify(file_path, ":t:r")
		vim.cmd("echohl MoreMsg")
		vim.cmd(string.format('echomsg "Session" "\'%s\'" "removed"', session))
		vim.cmd("echohl None")
		vim.cmd("silent !del " .. file_path)
	end

	local actions_state = require("telescope.actions.state")

	local opts = {
		initial_mode = "insert",
		cwd = vim.g.session_directory,
		prompt_title = "Sessions",
		attach_mappings = function(prompt_bufnr, map)
			-- Load session
			local load_session_map = function()
				local entry = actions_state.get_selected_entry()
				require("telescope.actions").close(prompt_bufnr)
				load_session(entry.value)
			end

			-- Delete session
			local delete_session_map = function()
				local entry = actions_state.get_selected_entry()
				delete_sesssion(entry.value)
			end

			-- Map <Enter> to load session
			require("telescope.actions.set").select:replace(load_session_map)
			-- Map <C-d> to delete session
			map("i", "<C-d>", delete_session_map)

			return true
		end,
	}

	require("telescope.builtin").find_files(opts)
end --}}}

-- Use dropdown theme with Frecency
M.frecency = function() --{{{
	local frecency_opts = M.dropdown({ prompt_title = "Recent Files" })
	require("telescope").extensions.frecency.frecency(frecency_opts)
end --}}}

return M
