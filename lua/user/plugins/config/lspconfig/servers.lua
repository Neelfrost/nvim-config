local M = {}

local _, lspconfig_util = pcall(require, "lspconfig.util")
local utils = require("user.plugins.config.lspconfig.utils")

-- Setup language servers
-- https://www.reddit.com/r/neovim/comments/r6gouy/migrating_from_nvim_051_to_nvim_060/hmvzsps/?context=3
-- Sumneko_lua vars
local sumneko_root_path = "C:\\tools\\lua-language-server"
local sumneko_binary = "C:\\tools\\lua-language-server\\bin\\lua-language-server.exe"
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

-- Omnisharp vars
local pid = vim.fn.getpid()
local omnisharp_bin = vim.split(vim.fn.trim(vim.fn.system("where omnisharp")), "\n")[1]

-- Specific server config
M.specific_configs = {
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
        root_pattern = lspconfig_util.root_pattern(".git", ".luarc.json", ".luacheckrc", ".stylua.toml", "selene.toml"),
        root_dir = function(fname)
            return lspconfig_util.root_pattern(".git", ".luarc.json", ".luacheckrc", ".stylua.toml", "selene.toml")(
                fname
            ) or lspconfig_util.path.dirname(fname)
        end,
    },
    omnisharp = {
        cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
        root_dir = function(fname)
            local dir = lspconfig_util.root_pattern(".csproj", ".sln")(fname) or lspconfig_util.path.dirname(fname)
            return vim.fn.has("win32") == 1 and string.format("'%s'", dir:lower()) or dir
        end,
    },
    html = {
        cmd = { "vscode-html-language-server.cmd", "--stdio" },
        -- Disable builtin formatter
        init_options = {
            provideFormatter = false,
        },
    },
    cssls = {
        cmd = { "vscode-css-language-server.cmd", "--stdio" },
    },
    eslint = {
        cmd = { "vscode-eslint-language-server.cmd", "--stdio" },
    },
    emmet_ls = {
        filetypes = { "html" },
    },
}

-- Common config for all servers
M.default_config = {
    on_attach = utils.on_attach,
    capabilities = require("cmp_nvim_lsp").update_capabilities(utils.capabilities),
    flags = {
        debounce_text_changes = 500,
    },
}

return M
