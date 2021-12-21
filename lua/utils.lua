--- Trim newline at eof, trailing whitespace.
function _G.perform_cleanup()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[
        keeppatterns %s/$\n\+\%$//e                      " removes trailing lines
        keeppatterns %s/\s\+$//e                         " removes trailing spaces
        keeppatterns %s/\r\+//e                          " removes linux line endings
    ]])
    if vim.bo.filetype == "tex" then
        vim.cmd([[
            keeppatterns %s/\\item$/\\item /e            " do not remove trailing space after LaTeX \item
            keeppatterns %s/\\task$/\\task /e            " do not remove trailing space after LaTeX \task
            keeppatterns %s/^\s*\\item\s*\\item/\\item/e " remove duplicate \items on sameline
        ]])
    end
    if require("plugins.config.lualine").mixed_indent() ~= "" then
        vim.cmd([[
            keeppatterns %s/\v\t/    /e
        ]])
    end

    local end_row = vim.api.nvim_buf_line_count(0)

    if pos[1] > end_row then
        pos[1] = end_row
    end

    vim.api.nvim_win_set_cursor(0, pos)
end

--- Quickfix toggle
--- https://vim.fandom.com/wiki/Toggle_to_open_or_close_the_quickfix_window
function _G.qfix_toggle(forced)
    if vim.g.qfix_win and forced then
        vim.cmd("cclose")
        vim.api.nvim_del_var("qfix_win")
    else
        vim.api.nvim_set_var("qfix_win", vim.fn.bufnr("$"))
        vim.cmd("copen 10")
    end
end
vim.cmd([[command! -bang -nargs=? QFix lua qfix_toggle(<bang>0)]])

--- Launch external program
--- @param prog string program to run
--- @vararg string args for program
function _G.launch_ext_prog(prog, ...)
    vim.api.nvim_command("!" .. prog .. " " .. table.concat({ ... }, " "))
    vim.cmd("redraw!")
end

-- Reloading lua modules using Telescope
-- taken and modified from:
-- https://ustrajunior.com/posts/reloading-neovim-config-with-telescope/

--- Pretty print lua tables
--- @param v table table to pretty print
--- @return table
function _G.verbose_print(v)
    print(vim.inspect(v))
    return v
end

if pcall(require, "plenary") then
    local reload = require("plenary.reload").reload_module
    --- Reload module using plenary
    --- @param name string module
    --- @return module module
    function _G.plenary_reload(name)
        reload(name)
        return require(name)
    end
end

--- Get module from file path
--- @param file_path string path to file e.g., "C:\Users\Neel\AppData\Local\nvim\lua\plugins\config\telescope.lua"
--- @return string module_name module representation of file "plugins.config.telescope"
function _G.get_module_name(file_path)
    -- Path to the lua folder
    local path_to_lua = CONFIG_PATH .. "\\lua\\"
    local module_name = file_path:gsub(path_to_lua, "")

    -- In the case that current file is not within "lua" folder
    if module_name == file_path then
        print("Not a valid module.")
        return nil
    end

    module_name = module_name:gsub("%.lua", "")
    module_name = module_name:gsub("\\", ".")
    module_name = module_name:gsub("%.init", "")
    return module_name
end

--- Save and reload a module
function _G.save_reload_module()
    local file_path = vim.fn.expand("%:p")
    if string.match(file_path, "\\\\") then
        file_path = file_path:gsub("\\\\", "\\")
    end
    local module = get_module_name(file_path)

    -- Only reload if current file is a valid module
    if module then
        -- Save
        vim.cmd("update!")
        -- Reload
        plenary_reload(module)
        -- Print
        print(module .. " Reloaded.")
    end
end

--- Set window title
function _G.set_title()
    local file = vim.fn.expand("%:p:t")
    local cwd = vim.fn.split(vim.fn.fnamemodify(file, ":p:h"):gsub("/", "\\"), "\\")
    local is_plugin = require("plugins.config.lualine").buffer_is_plugin()

    if file ~= "" and not is_plugin then
        vim.opt.titlestring = cwd[#cwd] .. "/" .. file
    else
        vim.opt.titlestring = "Neovim"
    end
end
