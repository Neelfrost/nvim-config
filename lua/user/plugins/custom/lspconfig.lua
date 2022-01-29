local M = {}

local util = pcall(require, "lspconfig.util")

M.show_line_diagnostics = function()
    local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = {
            { "┌", "FloatBorder" },
            { "─", "FloatBorder" },
            { "┐", "FloatBorder" },
            { "│", "FloatBorder" },
            { "┘", "FloatBorder" },
            { "─", "FloatBorder" },
            { "└", "FloatBorder" },
            { "│", "FloatBorder" },
        },
        source = "if_many",
        prefix = "",
    }
    vim.diagnostic.open_float(nil, opts)
end

-- Snippet, autocompletion support
M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
    },
}

-- Use the following when ls attches to a buffer
function M.on_attach(client, bufnr)
    local opts = { noremap = true, silent = true }
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    -- Mappings
    buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "gl", "<cmd>lua require('user.plugins.custom.lspconfig').show_line_diagnostics()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "gR", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

    -- Format on save if formatting is available
    if client.resolved_capabilities.document_formatting then
        vim.cmd([[
        augroup LSP_FORMAT
            autocmd! * <buffer>
            autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync(nil, 5000)
        augroup END
        ]])
    end
end

-- Setup language servers
-- https://www.reddit.com/r/neovim/comments/r6gouy/migrating_from_nvim_051_to_nvim_060/hmvzsps/?context=3
function M.setup_ls(lspconfig)
    -- Sumneko_lua vars
    local sumneko_root_path = "C:\\tools\\lua-language-server"
    local sumneko_binary = "C:\\tools\\lua-language-server\\bin\\lua-language-server.exe"
    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    -- Omnisharp vars
    local pid = vim.fn.getpid()
    local omnisharp_bin = vim.fn.trim(vim.fn.system("which omnisharp"))

    -- Specific server config
    local specific_configs = {
        sumneko_lua = {
            cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
            settings = {
                Lua = {
                    runtime = {
                        version = "LuaJIT",
                        path = runtime_path,
                    },
                    diagnostics = {
                        globals = { "vim", "use" },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        maxPreload = 10000,
                        preloadFileSize = 10000,
                        checkThirdParty = false,
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        },
        omnisharp = {
            cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
            root_dir = function(fname)
                local dir = util.root_pattern(".csproj", ".sln")(fname) or util.path.dirname(fname)
                return vim.fn.has("win32") == 1 and string.format("'%s'", dir:lower()) or dir
            end,
        },
    }

    -- Common config for all servers
    local default_config = {
        on_attach = M.on_attach,
        capabilities = require("cmp_nvim_lsp").update_capabilities(M.capabilities),
        flags = {
            debounce_text_changes = 500,
        },
    }

    -- Setup ls
    for _, lsp in ipairs(SERVERS) do
        local config = specific_configs[lsp] or {}
        config = vim.tbl_extend("keep", config, default_config)
        lspconfig[lsp].setup(config)
    end
end

return M
