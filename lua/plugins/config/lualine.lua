local M = {}
function M.BufIsPlugin()
	local plugins = { "NvimTree", "packer", "dashboard" }
	local filename = vim.fn.expand("%:t")
	for _, v in pairs(plugins) do
		if filename == v or vim.bo.filetype == v then
			return true
		end
	end
end

function M.FileIcon()
	local filename = vim.fn.expand("%:t")
	local icon = ""
	if not M.BufIsPlugin() and vim.fn.winwidth(0) > 70 and string.len(vim.bo.filetype) > 0 then
		icon = require("nvim-web-devicons").get_icon(filename, vim.bo.filetype) .. " "
	end
	return icon
end

function M.Filename()
	local filename = vim.fn.expand("%:t")
	local fname = filename == "NvimTree" and ""
		or filename == "packer" and ""
		or filename ~= "" and filename
		or "[No Name]"
	return M.Readonly() .. fname
end

function M.Readonly()
	local readonly = vim.api.nvim_exec([[echo &readonly || !&modifiable ? ' ' : '']], true)
	return readonly
end

function M.Mode()
	local fname = vim.fn.expand("%:t")

	local plugins = {
		NvimTree = "NVIMTREE",
		packer = "PACKER",
		dashboard = "DASHBOARD",
		mode = require("lualine.utils.mode").get_mode(),
	}

	for k, v in pairs(plugins) do
		if vim.bo.filetype == k or fname == k then
			return v
		end
	end

	return plugins["mode"]
end

function M.Paste()
	return vim.o.paste and "PASTE" or ""
end

function M.Wrap()
	return vim.o.wrap and "WRAP" or ""
end

function M.Spell()
	return vim.wo.spell and vim.bo.spelllang or ""
end

function M.FileFormat()
	local fileformat = ""
	if not M.BufIsPlugin() and vim.fn.winwidth(0) > 70 then
		fileformat = vim.bo.fileformat
	end
	return fileformat
end

function M.FileEncoding()
	local fileencoding = ""
	if not M.BufIsPlugin() and vim.fn.winwidth(0) > 70 then
		fileencoding = vim.bo.fileencoding
	end
	return fileencoding
end

function M.BufPercent()
	return vim.fn.winwidth(0) > 70 and string.format(
		"並%d%% of %d",
		(100 * vim.fn.line(".") / vim.fn.line("$")),
		vim.fn.line("$")
	) or ""
end

function M.LineInfo()
	return vim.fn.winwidth(0) > 70 and string.format("Ln %d, Col %-2d", vim.fn.line("."), vim.fn.col(".")) or ""
end

function M.TotalLines()
	return vim.fn.winwidth(0) > 70 and string.format("%d ﲯ", vim.fn.line("$")) or ""
end

-- https://github.com/samrath2007/kyoto.nvim/blob/main/lua/plugins/statusline.lua
function M.LspProgress()
	local messages = vim.lsp.util.get_progress_messages()
	if #messages == 0 then
		return
	end
	local status = {}
	for _, msg in pairs(messages) do
		table.insert(status, (msg.percentage or 0) .. "%% " .. (msg.title or ""))
	end
	local spinners = {
		"⠋",
		"⠙",
		"⠹",
		"⠸",
		"⠼",
		"⠴",
		"⠦",
		"⠧",
		"⠇",
		"⠏",
	}
	local ms = vim.loop.hrtime() / 1000000
	local frame = math.floor(ms / 120) % #spinners
	return vim.fn.winwidth(0) > 70 and table.concat(status, " | ") .. " " .. spinners[frame + 1] or ""
end

return M
