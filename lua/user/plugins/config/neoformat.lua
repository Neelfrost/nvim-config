vim.g.neoformat_lua_stylua = {
    exe = "stylua",
    args = { "--stdin-filepath", '"%:p"', "--config-path", '"C:\\Users\\Neel\\.stylua.toml"', "--", "-" },
    stdin = 1,
}
vim.g.neoformat_tex_latexindent = {
    exe = "latexindent",
    args = { "-g /dev/stderr", "2>/dev/null", "-d" },
    stdin = 1,
}

vim.g.neoformat_run_all_formatters = 1
vim.g.neoformat_enabled_python = { "isort", "black" }
vim.g.neoformat_enabled_lua = { "stylua" }
vim.g.neoformat_enabled_tex = { "latexindent" }
