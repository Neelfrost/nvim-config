local M = {}

local fn = vim.fn
local half_winwidth = 88

M.buffer_is_plugin = function() --{{{
	local plugins = { "NvimTree", "packer", "dashboard" }
	local filename = fn.expand("%:t")
	for _, v in pairs(plugins) do
		if filename == v or vim.bo.filetype == v then
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
	local plugins = { "NvimTree", "packer", "dashboard" }
	local file_name = fn.expand("%:r")
	local file_type = fn.expand("%:e")

	-- Truncate file_name if too big
	-- Set file name to [No Name] on empty buffers
	if #file_name > 15 then
		file_name = string.sub(file_name, 1, 8) .. "⋯"
	elseif file_name == "" then
		file_name = "[No Name]"
	end

	-- Join file_name and file_type if file_type exists
	local final_name = file_type ~= "" and file_name .. "." .. file_type or file_name

	-- Empty file_name for plugin releated buffers
	for _, v in pairs(plugins) do
		if v == vim.bo.filetype then
			final_name = "⋯"
		end
	end

	return M.readonly() .. M.file_icon(final_name, file_type)
end --}}}

M.readonly = function() --{{{
	local readonly = vim.api.nvim_exec([[echo &readonly || !&modifiable ? ' ' : '']], true)
	return readonly
end --}}}

M.current_mode = function() --{{{
	local buffer_name = fn.expand("%:t")
	local plugins = {
		NvimTree = "NVIMTREE",
		packer = "PACKER",
		dashboard = "DASHBOARD",
		mode = require("lualine.utils.mode").get_mode(),
	}

	-- Return mode if in command mode
	if fn.mode() == "c" then
		return plugins["mode"]
	end

	-- Return plugin name
	for k, v in pairs(plugins) do
		if vim.bo.filetype == k or buffer_name == k then
			return v
		end
	end

	-- Return mode
	return plugins["mode"]
end --}}}

M.git_branch = function() --{{{
	local icon = " "
	local git_branch = require("lualine.components.branch.git_branch")
	git_branch.init()

	local branch = git_branch.get_branch()

	if branch ~= "" and not M.buffer_is_plugin() then
		return icon .. branch
	end
	return ""
end --}}}

M.paste = function() --{{{
	return vim.o.paste and "PASTE" or ""
end --}}}

M.wrap = function() --{{{
	return vim.o.wrap and "WRAP" or ""
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

M.buffer_percent = function() --{{{
	return fn.winwidth(0) > half_winwidth and string.format(
		"並%d%% of %d",
		(100 * fn.line(".") / fn.line("$")),
		fn.line("$")
	) or ""
end --}}}

M.line_info = function() --{{{
	if not M.buffer_is_plugin() then
		if fn.winwidth(0) > half_winwidth then
			return string.format("Ln %d, Col %-2d", fn.line("."), fn.col("."))
		else
			return string.format("%d : %-2d", fn.line("."), fn.col("."))
		end
	else
		return ""
	end
end --}}}

M.total_lines = function() --{{{
	return not M.buffer_is_plugin() and string.format("%d ﲯ", fn.line("$")) or ""
end --}}}

M.lsp_client_name = function() --{{{
	local clients = vim.lsp.get_active_clients()
	for _, client in pairs(clients) do
		local client_filetype = client.config.filetypes[1]
		local client_name = client.name
		if client_filetype == vim.bo.filetype then
			return client_name
		end
	end
	return ""
end --}}}

M.lsp_status = function() --{{{
	-- https://github.com/samrath2007/kyoto.nvim/blob/main/lua/plugins/statusline.lua
	local messages = vim.lsp.util.get_progress_messages()
	local client_name = M.lsp_client_name()

	-- Show client if client has been loaded
	if #messages == 0 then
		return client_name
	end

	-- Show client load progress
	local status = {}
	for _, msg in pairs(messages) do
		table.insert(status, (msg.percentage or 0) .. "%% " .. (msg.title or ""))
	end

	return fn.winwidth(0) > half_winwidth and table.concat(status, " | ") or ""
end --}}}

M.theme_transparent = function() --{{{
	local colors = {
		darkgray = "#1d1f21",
		gray = "#3f4b59",
		innerbg = "NONE",
		outerbg = "NONE",
		outerfg = "#14191f",
		insert = "#99c794",
		normal = "#6699cc",
		replace = "#ec5f67",
		visual = "#f99157",
	}
	return {
		inactive = {
			a = { fg = colors.gray, bg = colors.outerbg, gui = "bold" },
			b = { fg = colors.gray, bg = colors.outerfg },
			c = { fg = colors.gray, bg = colors.innerbg },
		},
		visual = {
			a = { fg = colors.darkgray, bg = colors.visual, gui = "bold" },
			b = { fg = colors.gray, bg = colors.outerfg },
			c = { fg = colors.gray, bg = colors.innerbg },
		},
		replace = {
			a = { fg = colors.darkgray, bg = colors.replace, gui = "bold" },
			b = { fg = colors.gray, bg = colors.outerfg },
			c = { fg = colors.gray, bg = colors.innerbg },
		},
		normal = {
			a = { fg = colors.darkgray, bg = colors.normal, gui = "bold" },
			b = { fg = colors.gray, bg = colors.outerfg },
			c = { fg = colors.gray, bg = colors.innerbg },
		},
		insert = {
			a = { fg = colors.darkgray, bg = colors.insert, gui = "bold" },
			b = { fg = colors.gray, bg = colors.outerfg },
			c = { fg = colors.gray, bg = colors.innerbg },
		},
		command = {
			a = { fg = colors.darkgray, bg = colors.insert, gui = "bold" },
			b = { fg = colors.gray, bg = colors.outerfg },
			c = { fg = colors.gray, bg = colors.innerbg },
		},
	}
end --}}}

return M
