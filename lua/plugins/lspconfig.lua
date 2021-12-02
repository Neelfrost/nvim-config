-- Default diagnostic settings
vim.diagnostic.config({
    virtual_text = {
        source = "if_many",
        prefix = "●",
    },
    signs = true,
    underline = true,
    update_in_insert = true,
    severity_sort = false,
})

-- Set completion icons
vim.fn.sign_define("DiagnosticsSignError", { text = ICON_ERROR })
vim.fn.sign_define("DiagnosticsSignWarning", { text = ICON_WARN })
vim.fn.sign_define("DiagnosticsSignInformation", { text = ICON_INFO })
vim.fn.sign_define("DiagnosticsSignHint", { text = ICON_HINT })

-- Define borders
local borders = {
    { "┌", "FloatBorder" },
    { "─", "FloatBorder" },
    { "┐", "FloatBorder" },
    { "│", "FloatBorder" },
    { "┘", "FloatBorder" },
    { "─", "FloatBorder" },
    { "└", "FloatBorder" },
    { "│", "FloatBorder" },
}
-- Set borders
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = borders })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, { border = borders })

-- Snippet, autocompletion support
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
    },
}

local lspconfig = require("lspconfig")

-- Setup language servers
require("plugins.config.lspconfig").setup_ls(lspconfig, capabilities)
