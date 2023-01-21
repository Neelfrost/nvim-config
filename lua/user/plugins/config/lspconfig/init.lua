-- Default diagnostic settings
vim.diagnostic.config({
    virtual_text = {
        source = "if_many",
        prefix = " ",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false,
})

-- Set completion icons
vim.fn.sign_define("DiagnosticsSignError", { text = ICON_ERROR })
vim.fn.sign_define("DiagnosticsSignWarning", { text = ICON_WARN })
vim.fn.sign_define("DiagnosticsSignInformation", { text = ICON_INFO })
vim.fn.sign_define("DiagnosticsSignHint", { text = ICON_HINT })

-- Set square borders
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })

local present, lspconfig = pcall(require, "lspconfig")
if not present then
    return
end

-- Server configs
local servers = require("user.plugins.config.lspconfig.servers")

-- Setup language servers
for _, lsp in ipairs(SERVERS) do
    local config = servers.specific_configs[lsp] or {}
    config = vim.tbl_extend("keep", config, servers.default_config)
    lspconfig[lsp].setup(config)
end
