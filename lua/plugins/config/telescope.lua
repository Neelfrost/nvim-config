-- Custom telescope pickers
local M = {}

-- Find files in custom dirs
function M.dir_nvim()
	local opts = {
		prompt_title = "Neovim",
		shorten_path = false,
		cwd = CONFIG_PATH,
		file_ignore_patterns = { ".git", "tags" },
		initial_mode = "insert",
		selection_strategy = "reset",
		theme = require("telescope.themes").get_dropdown({}),
		previewer = false,
	}

	require("telescope.builtin").find_files(opts)
end

function M.dir_latex()
	local opts = {
		prompt_title = "LaTeX",
		shorten_path = false,
		cwd = HOME_PATH .. "\\Documents\\LaTeX",
		file_ignore_patterns = {
			".cb",
			".gz",
			".lb",
			".aux",
			".cb2",
			".fls",
			".fmt",
			".fot",
			".git",
			".jpg",
			".lof",
			".log",
			".lot",
			".nav",
			".otf",
			".out",
			".pdf",
			".pdf",
			".png",
			".snm",
			".toc",
			".ttf",
			".vrb",
			".zip",
			"tags",
			".synctex",
			"indent.log",
			".synctex.gz",
			".fdb_latexmk",
			".synctex(busy)",
		},
		initial_mode = "insert",
		selection_strategy = "reset",
		theme = require("telescope.themes").get_dropdown({}),
		previewer = false,
	}

	require("telescope.builtin").find_files(opts)
end

function M.dir_python()
	local opts = {
		prompt_title = "Python",
		shorten_path = false,
		cwd = "D:\\My Folder\\Dev\\Python",
		file_ignore_patterns = { ".git", "tags", "__pycache__" },
		initial_mode = "insert",
		selection_strategy = "reset",
		theme = require("telescope.themes").get_dropdown({}),
		previewer = false,
	}

	require("telescope.builtin").find_files(opts)
end

-- Reloading lua modules using Telescope
-- taken and modified from:
-- https://ustrajunior.com/posts/reloading-neovim-config-with-telescope/
function M.reload()
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

	local prompt_title = "Reload Neovim Modules"

	local opts = {
		prompt_title = prompt_title,
		cwd = path,
		theme = require("telescope.themes").get_dropdown({}),
		previewer = false,
		attach_mappings = function(prompt_bufnr, map)
			-- This will replace select no matter on which key it is mapped by default
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
end

-- Session list
function M.sessions()
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
		prompt_title = "Sessions",
		shorten_path = false,
		cwd = vim.g.session_directory,
		initial_mode = "insert",
		selection_strategy = "reset",
		theme = require("telescope.themes").get_dropdown({}),
		previewer = false,
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
end

return M
