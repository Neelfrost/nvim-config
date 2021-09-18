local M = {}

local function highlight(group, guifg, guibg, style) --{{{
	local list = { group }
	if guifg then
		table.insert(list, "guifg=" .. guifg)
	end
	if guibg then
		table.insert(list, "guibg=" .. guibg)
	end
	if style then
		table.insert(list, "gui=" .. style)
	end

	vim.api.nvim_command("highlight " .. table.concat(list, " "))
end --}}}

function M.gruvbox() --{{{
	-- Setup
	vim.g.gruvbox_material_show_eob = 1
	vim.g.gruvbox_material_palette = "mix"
	vim.g.gruvbox_material_background = "hard"
	-- vim.g.gruvbox_material_better_performance = 1
	vim.g.gruvbox_material_sign_column_background = "none"
	vim.g.gruvbox_material_enable_italic = 1
	-- Color overrides
	vim.g.gruvbox_material_palette = {
		none = { "NONE", "NONE" },
		bg0 = { "#14171c", "234" },
		bg1 = { "#191d24", "235" },
		bg2 = { "#191d24", "235" },
		bg3 = { "#3c3836", "237" },
		bg4 = { "#3c3836", "237" },
		bg5 = { "#504945", "239" },
		fg0 = { "#e2cca9", "223" },
		fg1 = { "#e2cca9", "223" },
		red = { "#f2594b", "167" },
		aqua = { "#8bba7f", "108" },
		blue = { "#80aa9e", "109" },
		green = { "#b0b846", "142" },
		grey0 = { "#7c6f64", "243" },
		grey1 = { "#928374", "245" },
		grey2 = { "#928374", "246" },
		bg_blue = { "#36a3d9", "4" },
		orange = { "#f28534", "208" },
		yellow = { "#e9b143", "214" },
		purple = { "#d3869b", "175" },
		bg_red = { "#db4740", "167" },
		bg_green = { "#b0b846", "142" },
		bg_yellow = { "#e9b143", "214" },
		bg_diff_red = { "#3c1f1e", "52" },
		bg_diff_blue = { "#0d3138", "17" },
		bg_diff_green = { "#32361a", "22" },
		bg_visual_red = { "#442e2d", "52" },
		bg_visual_blue = { "#2e3b3b", "17" },
		bg_statusline1 = { "#191d24", "235" },
		bg_statusline2 = { "#32302f", "235" },
		bg_statusline3 = { "#504945", "239" },
		bg_visual_green = { "#333e34", "22" },
		bg_visual_yellow = { "#473c29", "94" },
		bg_current_word = { "#32302f", "236" },
	}
	-- Apply custom highlights
	vim.cmd([[
        augroup GRUVBOX_HIGHLIGHTS
            autocmd!
            autocmd ColorScheme gruvbox-material lua require("themes").gruvbox_highlights()
        augroup END
    ]])
	-- Set theme
	vim.cmd([[colorscheme gruvbox-material]])
end --}}}

function M.gruvbox_highlights() --{{{
	local palette = vim.g.gruvbox_material_palette
	-- Remove float background, fix compe backgroup
	highlight("Normalfloat", "NONE", "NONE")
	highlight("Floatborder", palette.bg_blue[1], "NONE")
	highlight("CompeDocumentation", nil, palette.bg3[1])
	highlight("CompeDocumentationBorder", nil, palette.bg3[1])
	-- SpellBad
	highlight("SpellBad", palette.red[1], "NONE", "bold")
	-- Telescope
	highlight("TelescopeBorder", palette.bg_blue[1], "NONE")
	highlight("TelescopeMatching", palette.bg_red[1], "NONE")
	highlight("TelescopePromptPrefix", palette.bg_red[1], "NONE")
	highlight("TelescopeSelectionCaret", palette.bg_red[1], "NONE")
	highlight("TelescopePromptBorder", palette.bg_blue[1], "NONE")
	highlight("TelescopeResultsBorder", palette.bg_blue[1], "NONE")
	highlight("TelescopePreviewBorder", palette.bg_blue[1], "NONE")
	-- Barbar
	highlight("BufferCurrent", palette.bg_blue[1], palette.bg0[1])
	highlight("BufferCurrent", palette.bg_blue[1], palette.bg0[1])
	highlight("BufferCurrentMod", palette.bg_red[1], palette.bg0[1])
	highlight("BufferCurrentIcon", palette.grey0[1], palette.bg0[1])
	highlight("BufferCurrentIndex", palette.grey0[1], palette.bg0[1])
	highlight("BufferCurrentSign", palette.bg_blue[1], palette.bg0[1])
	highlight("BufferVisible", palette.fg0[1], palette.bg1[1])
	highlight("BufferVisibleMod", palette.bg_red[1], palette.bg1[1])
	highlight("BufferVisibleIcon", palette.grey0[1], palette.bg1[1])
	highlight("BufferVisibleIndex", palette.grey0[1], palette.bg1[1])
	highlight("BufferVisibleSign", palette.fg0[1], palette.bg1[1])
	highlight("BufferInactive", palette.grey0[1], palette.bg1[1])
	highlight("BufferInactiveMod", palette.bg_red[1], palette.bg1[1])
	highlight("BufferInactiveIcon", palette.grey0[1], palette.bg1[1])
	highlight("BufferInactiveSign", palette.grey0[1], palette.bg1[1])
	highlight("BufferInactiveIndex", palette.grey0[1], palette.bg1[1])
	-- Dashboard
	highlight("dashboardHeader", palette.bg_blue[1])
	highlight("dashboardFooter", palette.red[1])
	-- Nvimtree
	highlight("NvimTreeFolderName", palette.bg_blue[1])
	highlight("NvimTreeFolderIcon", palette.bg_blue[1])
	highlight("NvimTreeEmptyFolderName", palette.bg_blue[1])
	highlight("NvimTreeOpenedFolderName", palette.bg_blue[1])
	-- Treesitter
	highlight("TSConstructor", palette.yellow[1])
	-- Fold
	highlight("Folded", palette.grey1[1], nil, "italic")
	-- CursorLineNr
	highlight("CursorLineNr", palette.bg_blue[1], nil, "bold")
end --}}}

return M
