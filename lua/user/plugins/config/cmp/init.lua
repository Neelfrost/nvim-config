local icons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "⌘",
    Field = "ﰠ",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "塞",
    Value = "",
    Enum = "",
    Keyword = "廓",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = "",
}

local feedkey = function(key, mode)
    mode = mode or "n"
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require("cmp")
local cmp_mappings = require("user.plugins.config.cmp.mappings")

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            vim_item.menu = vim_item.kind
                .. " "
                .. ({
                    omni = "[Omni]",
                    buffer = "[Buf]",
                    nvim_lsp = "[Lsp]",
                    nvim_lua = "[Lua]",
                    ultisnips = "[Snip]",
                    path = "[Path]",
                })[entry.source.name]
            vim_item.kind = icons[vim_item.kind]
            return vim_item
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-n>"] = cmp.mapping.scroll_docs(4),
        ["<C-p>"] = cmp.mapping.scroll_docs(-4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-c>"] = cmp.mapping.close(),
        ["<Tab>"] = cmp.mapping(function(fallback)
            cmp_mappings.compose({ "expand", "jump_forwards", "confirm" })(fallback)
        end, {
            "i",
            "s",
        }),
        ["<C-e>"] = cmp.mapping(function(fallback)
            cmp_mappings.compose({ "confirm" })(fallback)
        end, {
            "i",
            "s",
        }),
    }),
    sources = cmp.config.sources({
        { name = "ultisnips" },
        { name = "nvim_lsp" },
        {
            name = "buffer",
            option = {
                get_bufnrs = function()
                    local bufs = {}
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        bufs[vim.api.nvim_win_get_buf(win)] = true
                    end
                    return vim.tbl_keys(bufs)
                end,
            },
        },
        { name = "nvim_lua" },
        { name = "path" },
    }),
    window = {
        documentation = {
            winhighlight = "NormalFloat:CmpDocumentation,FloatBorder:CmpDocumentationBorder",
        },
    },
    experimental = {
        ghost_text = true,
    },
})

local cmdline_formatting = {
    format = function(_, vim_item)
        vim_item.kind = ""
        vim_item.menu = ""
        return vim_item
    end,
}

local cmdline_mapping = cmp.mapping.preset.insert({
    ["<C-j>"] = cmp.mapping({
        c = function()
            if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            else
                feedkey("<Down>")
            end
        end,
    }),
    ["<C-k>"] = cmp.mapping({
        c = function()
            if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            else
                feedkey("<Up>")
            end
        end,
    }),
    ["<Tab>"] = cmp.mapping({
        c = function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = true })
            else
                fallback()
            end
        end,
    }),
})

cmp.setup.cmdline("/", {
    formatting = cmdline_formatting,
    mapping = cmdline_mapping,
    sources = cmp.config.sources({
        { name = "buffer" },
    }),
})

cmp.setup.cmdline(":", {
    formatting = cmdline_formatting,
    mapping = cmdline_mapping,
    sources = cmp.config.sources({
        { name = "cmdline" },
        { name = "buffer" },
        { name = "path" },
    }),
})
