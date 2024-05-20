local null_present, null_ls = pcall(require, "null-ls")
if not null_present then
    return
end

local utils = require("user.plugins.config.lspconfig.utils")
local null_ls_sources = require("user.plugins.config.null_ls.sources")

local sources = {
    -- Formatters
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.stylua.with({
        extra_args = {
            "--config-path",
            vim.fn.expand("~/.stylua.toml"),
        },
    }),
    null_ls_sources.latexindent,
    -- Diagnostics
    null_ls_sources.chktex,
}

null_ls.setup({
    debounce = 500,
    default_timeout = 10000,
    diagnostics_format = "#{m} (#{s})",
    sources = sources,
    on_attach = utils.on_attach,
})
