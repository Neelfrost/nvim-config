local cmp = require("cmp")
cmp.setup.filetype("tex", {
    sources = cmp.config.sources({
        { name = "omni" },
        { name = "ultisnips" },
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
        { name = "path" },
    }),
})
