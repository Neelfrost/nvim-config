local null_present, null_ls
local lsp_present, _ = pcall(require, "lspconfig")
if lsp_present then
    null_present, null_ls = pcall(require, "null-ls")
    if not null_present then
        vim.cmd("PackerCompile")
        return
    end
else
    vim.cmd("PackerCompile")
    return
end

local lspconfig = require("user.plugins.custom.lspconfig")
local helper = require("null-ls.helpers")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING

local latexindent = helper.make_builtin({
    method = FORMATTING,
    filetypes = { "tex" },
    generator_opts = {
        command = "latexindent.exe",
        args = {
            "-d",
        },
        to_stdin = true,
    },
    factory = helper.formatter_factory,
})

local sources = {
    -- Formatters
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.stylua.with({
        extra_args = { "--config-path", vim.fn.expand("~/.stylua.toml") },
    }),
    null_ls.builtins.formatting.black,
    latexindent,
    -- Diagnostics
    null_ls.builtins.diagnostics.flake8.with({
        extra_args = {
            "--config",
            vim.fn.expand("~/.flake8"),
        },
    }),
    null_ls.builtins.diagnostics.chktex.with({
        from_stderr = true,
        args = { "-I", "-q", "-f%l:%c:%d:%k:%m\r\n" },
    }),
}

null_ls.setup({
    debounce = 500,
    default_timeout = 5000,
    diagnostics_format = "#{m} (#{s})",
    sources = sources,
    on_attach = lspconfig.on_attach,
    capabilities = require("cmp_nvim_lsp").update_capabilities(lspconfig.capabilities),
})
