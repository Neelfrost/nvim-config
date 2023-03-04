local M = {}

local _, lspconfig_util = pcall(require, "lspconfig.util")
local utils = require("user.plugins.config.lspconfig.utils")

-- Setup language servers
-- https://www.reddit.com/r/neovim/comments/r6gouy/migrating_from_nvim_051_to_nvim_060/hmvzsps/?context=3

-- Omnisharp vars
local omnisharp_dll = [[C:\tools\omnisharp\OmniSharp.dll]]

-- Specific server config
M.specific_configs = {
    lua_ls = {
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                diagnostics = {
                    globals = { "vim" },
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
        cmd = { "dotnet", omnisharp_dll },
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
        root_dir = lspconfig_util.root_pattern(
            ".eslintrc",
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.yaml",
            ".eslintrc.yml",
            ".eslintrc.json",
            "package.json",
            ".git"
        ),
        settings = { format = false },
    },
    emmet_ls = {
        filetypes = { "html" },
    },
}

-- Common config for all servers
M.default_config = {
    on_attach = utils.on_attach,
    capabilities = utils.capabilities,
    flags = {
        debounce_text_changes = 500,
    },
}

return M
