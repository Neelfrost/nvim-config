local M = {}

-- Snippet, autocompletion support
M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    },
}
M.capabilities = require("cmp_nvim_lsp").default_capabilities(M.capabilities)

-- Use the following when ls attches to a buffer
M.on_attach = function(client, bufnr)
    -- Mappings
    local opts = { buffer = bufnr, silent = true }
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "gl", function()
        local float_opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "single",
            source = "if_many",
            prefix = "",
        }
        vim.diagnostic.open_float(nil, float_opts)
    end, opts)
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "gR", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)

    -- Format on save if formatting is available
    if client.server_capabilities.documentFormattingProvider
        or client.server_capabilities.documentRangeFormattingProvider
    then
        local group = vim.api.nvim_create_augroup("lsp_format_onsave", { clear = false })
        vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ timeout_ms = 2000 })
            end,
            desc = "Format using lsp/null-ls on save.",
            group = group,
        })
    end
end

return M
