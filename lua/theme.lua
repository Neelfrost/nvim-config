local M = {}

function M.gruvbox()
	-- Gruvbox Material
	vim.g.gruvbox_material_palette = "mix"
	vim.g.gruvbox_material_better_performance = 1
	vim.g.gruvbox_material_sign_column_background = "none"
	vim.g.gruvbox_material_background = "hard"
	vim.g.gruvbox_material_show_eob = 1

	-- Changes: darker bg0, bg1, Addition: bg_blue
	vim.g.gruvbox_material_palette = {
		bg0 = { "#14171c", "234" },
		bg1 = { "#191d24", "235" },
		bg2 = { "#191d24", "235" },
		bg3 = { "#3c3836", "237" },
		bg4 = { "#3c3836", "237" },
		bg5 = { "#504945", "239" },
		bg_statusline1 = { "#191d24", "235" },
		bg_statusline2 = { "#32302f", "235" },
		bg_statusline3 = { "#504945", "239" },
		bg_diff_green = { "#32361a", "22" },
		bg_visual_green = { "#333e34", "22" },
		bg_diff_red = { "#3c1f1e", "52" },
		bg_visual_red = { "#442e2d", "52" },
		bg_diff_blue = { "#0d3138", "17" },
		bg_visual_blue = { "#2e3b3b", "17" },
		bg_visual_yellow = { "#473c29", "94" },
		bg_current_word = { "#32302f", "236" },
		fg0 = { "#e2cca9", "223" },
		fg1 = { "#e2cca9", "223" },
		red = { "#f2594b", "167" },
		orange = { "#f28534", "208" },
		yellow = { "#e9b143", "214" },
		green = { "#b0b846", "142" },
		aqua = { "#8bba7f", "108" },
		blue = { "#80aa9e", "109" },
		purple = { "#d3869b", "175" },
		bg_red = { "#db4740", "167" },
		bg_green = { "#b0b846", "142" },
		bg_yellow = { "#e9b143", "214" },
		grey0 = { "#7c6f64", "243" },
		grey1 = { "#928374", "245" },
		grey2 = { "#928374", "246" },
		none = { "NONE", "NONE" },
		bg_blue = { "#36a3d9", "4" },
	}

	-- Custom highlights
	-- https://github.com/sainnhe/gruvbox-material/blob/master/doc/gruvbox-material.txt
	function _G.gruvbox_material_custom()
		-- Link a highlight group to a predefined highlight group.
		-- See `colors/gruvbox-material.vim` for all predefined highlight groups.
		-- Initialize the color palette.
		-- The first parameter is a valid value for `g:gruvbox_material_background`,
		-- and the second parameter is a valid value for `g:gruvbox_material_palette`.

		local palette = vim.g.gruvbox_material_palette

		-- Define a highlight group.
		-- The first parameter is the name of a highlight group,
		-- the second parameter is the foreground color,
		-- the third parameter is the background color,
		-- the fourth parameter is for UI highlighting which is optional,
		-- and the last parameter is for `guisp` which is also optional.
		-- See `autoload/gruvbox_material.vim` for the format of `l:palette`.

		-- Barbar
		vim.fn["gruvbox_material#highlight"]("BufferCurrent", palette.bg_blue, palette.bg0, "bold")
		vim.fn["gruvbox_material#highlight"]("BufferCurrent", palette.bg_blue, palette.bg0, "bold")
		vim.fn["gruvbox_material#highlight"]("BufferCurrentIndex", palette.grey0, palette.bg0, "bold")
		vim.fn["gruvbox_material#highlight"]("BufferCurrentMod", palette.bg_red, palette.bg0, "bold")
		vim.fn["gruvbox_material#highlight"]("BufferCurrentIcon", palette.grey0, palette.bg0)
		vim.fn["gruvbox_material#highlight"]("BufferCurrentSign", palette.bg_blue, palette.bg0)
		vim.fn["gruvbox_material#highlight"]("BufferVisible", palette.bg_blue, palette.bg1)
		vim.fn["gruvbox_material#highlight"]("BufferVisibleIndex", palette.grey0, palette.bg1)
		vim.fn["gruvbox_material#highlight"]("BufferVisibleMod", palette.bg_red, palette.bg1)
		vim.fn["gruvbox_material#highlight"]("BufferVisibleIcon", palette.grey0, palette.bg1)
		vim.fn["gruvbox_material#highlight"]("BufferVisibleSign", palette.bg_blue, palette.bg1)
		vim.fn["gruvbox_material#highlight"]("BufferInactive", palette.grey0, palette.bg1)
		vim.fn["gruvbox_material#highlight"]("BufferInactiveIndex", palette.grey0, palette.bg1)
		vim.fn["gruvbox_material#highlight"]("BufferInactiveMod", palette.bg_red, palette.bg1)
		vim.fn["gruvbox_material#highlight"]("BufferInactiveIcon", palette.grey0, palette.bg1)
		vim.fn["gruvbox_material#highlight"]("BufferInactiveSign", palette.grey0, palette.bg1)
		-- Spell
		vim.fn["gruvbox_material#highlight"]("SpellBad", palette.red, palette.none, "bold")
		-- Lsp
		vim.fn["gruvbox_material#highlight"]("Normalfloat", palette.none, palette.bg0)
		vim.fn["gruvbox_material#highlight"]("Floatborder", palette.blue, palette.bg0)
		-- Telescope
		vim.fn["gruvbox_material#highlight"]("TelescopeBorder", palette.bg_blue, palette.none)
		vim.fn["gruvbox_material#highlight"]("TelescopePromptBorder", palette.bg_blue, palette.none)
		vim.fn["gruvbox_material#highlight"]("TelescopeResultsBorder", palette.bg_blue, palette.none)
		vim.fn["gruvbox_material#highlight"]("TelescopePreviewBorder", palette.bg_blue, palette.none)
		vim.fn["gruvbox_material#highlight"]("TelescopePromptPrefix", palette.red, palette.none)
		vim.fn["gruvbox_material#highlight"]("TelescopeMatching", palette.red, palette.none, "bold")
		-- Dashboard
		vim.fn["gruvbox_material#highlight"]("dashboardHeader", palette.bg_blue, palette.none)
		vim.fn["gruvbox_material#highlight"]("dashboardFooter", palette.red, palette.none)
		-- Compe
		vim.fn["gruvbox_material#highlight"]("CompeDocumentation", palette.fg1, palette.bg3)
		vim.fn["gruvbox_material#highlight"]("CompeDocumentationBorder", palette.fg1, palette.bg3)
	end

	-- Apply custom highlights
	vim.cmd([[
        augroup GRUVBOXMATERIALCUSTOM
        autocmd!
        autocmd ColorScheme gruvbox-material lua gruvbox_material_custom()
        augroup END
    ]])

	-- Set colorscheme
	-- vim.cmd([[colorscheme gruvbox-material]])
end

function M.rosepine()
	vim.g.rose_pine_variant = "base"

	-- Set colorscheme
	-- vim.cmd([[colorscheme rose-pine]])
end

function M.srcery()
	vim.g.srcery_inverse = 0
	vim.g.srcery_inverse_match_paren = 1
	-- Color overides
	vim.g.srcery_black = "#14171c"

	-- Set colorscheme
	vim.cmd([[colorscheme srcery]])
end

return M
