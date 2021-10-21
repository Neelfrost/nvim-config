local icons = {
	Text = "",
	Method = "",
	Function = "",
	Constructor = "",
	Field = "ﰠ",
	Variable = "",
	Class = "ﴯ",
	Interface = "",
	Module = "",
	Property = "ﰠ",
	Unit = "塞",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "פּ",
	Event = "",
	Operator = "",
	TypeParameter = "",
}

local has_words_before = function()
	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
		return false
	end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
	mode = mode or "n"
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["UltiSnips#Anon"](args.body)
		end,
	},
	formatting = {
		format = function(entry, vim_item)
			vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
			vim_item.menu = ({
				omni = "[Omni]",
				buffer = "[Buf]",
				nvim_lsp = "[Lsp]",
				nvim_lua = "[Lua]",
				ultisnips = "[Snip]",
			})[entry.source.name]
			return vim_item
		end,
	},
	mapping = {
		["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<Tab>"] = cmp.mapping(function(fallback)
			if vim.fn.complete_info()["selected"] == -1 and vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
				feedkey("<C-R>=UltiSnips#ExpandSnippet()<CR>")
			elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
				feedkey("<ESC>:call UltiSnips#JumpForwards()<CR>")
			elseif has_words_before() then
				cmp.confirm({ select = true })
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<C-o>"] = cmp.mapping(function(fallback)
			if vim.fn.pumvisible() == 1 then
				cmp.close()
			elseif has_words_before() then
				feedkey("<C-x><C-o>")
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	},
	sources = {
		{ name = "ultisnips" },
		{ name = "nvim_lsp" },
		{ name = "buffer" },
	},
	documentation = {
		winhighlight = "NormalFloat:CmpDocumentation,FloatBorder:CmpDocumentationBorder",
	},
	experimental = {
		ghost_text = true,
	},
})
