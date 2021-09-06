local M = {}

local function hifg(group, fg)
	vim.cmd("highlight " .. group .. " guifg = " .. fg)
end

local function hibg(group, bg)
	vim.cmd("highlight " .. group .. " guibg = " .. bg)
end

local function hifgbg(group, fg, bg)
	vim.cmd("highlight " .. group .. " guifg = " .. fg .. " guibg = " .. bg)
end

local function hifgbgs(group, fg, bg, style)
	vim.cmd("highlight " .. group .. " guifg = " .. fg .. " guibg = " .. bg .. " gui = " .. style)
end

local function hilink(group1, group2)
	vim.cmd("highlight clear " .. group1)
	vim.cmd("highlight link " .. group1 .. " " .. group2)
end

function M.gruvbox() --{{{
	-- Setup
	vim.g.gruvbox_material_show_eob = 1
	vim.g.gruvbox_material_palette = "mix"
	vim.g.gruvbox_material_background = "hard"
	vim.g.gruvbox_material_better_performance = 1
	vim.g.gruvbox_material_sign_column_background = "none"
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
	hifgbg("Normalfloat", "NONE", "NONE")
	hifgbg("Floatborder", palette.bg_blue[1], "NONE")
	hibg("CompeDocumentation", palette.bg3[1])
	hibg("CompeDocumentationBorder", palette.bg3[1])
	-- SpellBad
	hifgbgs("SpellBad", palette.red[1], "NONE", "bold")
	-- Telescope
	hifgbg("TelescopeBorder", palette.bg_blue[1], "NONE")
	hifgbg("TelescopeMatching", palette.bg_red[1], "NONE")
	hifgbg("TelescopePromptPrefix", palette.bg_red[1], "NONE")
	hifgbg("TelescopeSelectionCaret", palette.bg_red[1], "NONE")
	hifgbg("TelescopePromptBorder", palette.bg_blue[1], "NONE")
	hifgbg("TelescopeResultsBorder", palette.bg_blue[1], "NONE")
	hifgbg("TelescopePreviewBorder", palette.bg_blue[1], "NONE")
	-- Barbar
	hifgbg("BufferCurrent", palette.bg_blue[1], palette.bg0[1])
	hifgbg("BufferCurrent", palette.bg_blue[1], palette.bg0[1])
	hifgbg("BufferCurrentMod", palette.bg_red[1], palette.bg0[1])
	hifgbg("BufferCurrentIcon", palette.grey0[1], palette.bg0[1])
	hifgbg("BufferCurrentIndex", palette.grey0[1], palette.bg0[1])
	hifgbg("BufferCurrentSign", palette.bg_blue[1], palette.bg0[1])
	hifgbg("BufferVisible", palette.fg0[1], palette.bg1[1])
	hifgbg("BufferVisibleMod", palette.bg_red[1], palette.bg1[1])
	hifgbg("BufferVisibleIcon", palette.grey0[1], palette.bg1[1])
	hifgbg("BufferVisibleIndex", palette.grey0[1], palette.bg1[1])
	hifgbg("BufferVisibleSign", palette.fg0[1], palette.bg1[1])
	hifgbg("BufferInactive", palette.grey0[1], palette.bg1[1])
	hifgbg("BufferInactiveMod", palette.bg_red[1], palette.bg1[1])
	hifgbg("BufferInactiveIcon", palette.grey0[1], palette.bg1[1])
	hifgbg("BufferInactiveSign", palette.grey0[1], palette.bg1[1])
	hifgbg("BufferInactiveIndex", palette.grey0[1], palette.bg1[1])
	-- Dashboard
	hifg("dashboardHeader", palette.bg_blue[1])
	hifg("dashboardFooter", palette.red[1])
	-- Nvimtree
	hifg("NvimTreeFolderName", palette.bg_blue[1])
	hifg("NvimTreeFolderIcon", palette.bg_blue[1])
	hifg("NvimTreeEmptyFolderName", palette.bg_blue[1])
	hifg("NvimTreeOpenedFolderName", palette.bg_blue[1])
end --}}}

return M
