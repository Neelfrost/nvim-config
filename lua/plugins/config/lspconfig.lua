local M = {}

function M.language_servers(lspconfig, on_attach, capabilities)
	-- Language servers:
	local servers = { "pyright", "sumneko_lua", "omnisharp" }

	-- Setup language servers
	for _, lsp in ipairs(servers) do
		if lsp == "sumneko_lua" then
			local sumneko_root_path = "C:\\tools\\lua-language-server"
			local sumneko_binary = "C:\\tools\\lua-language-server\\bin\\lua-language-server.exe"
			local runtime_path = vim.split(package.path, ";")
			table.insert(runtime_path, "lua/?.lua")
			table.insert(runtime_path, "lua/?/init.lua")
			lspconfig[lsp].setup({
				on_attach = on_attach,
				capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities),
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
			})
		elseif lsp == "omnisharp" then
			local pid = vim.fn.getpid()
			local omnisharp_bin = vim.fn.trim(vim.fn.system("which omnisharp"))
			lspconfig[lsp].setup({
				on_attach = on_attach,
				capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities),
				cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
			})
		else
			lspconfig[lsp].setup({
				on_attach = on_attach,
				capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities),
			})
		end
	end
end

return M
