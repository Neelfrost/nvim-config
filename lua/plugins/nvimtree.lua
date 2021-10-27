vim.cmd([[
    augroup NVIMTREE
        autocmd!
        autocmd BufEnter NvimTree setlocal scrolloff=8 | setlocal fillchars=eob:\ ,
    augroup END
]])

vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_quit_on_open = 1
vim.g.nvim_tree_ignore = {
    -- tex
    "*.cb",
    "*.gz",
    "*.aux",
    "*.cb2",
    "*.fls",
    "*.fmt",
    "*.fot",
    "*.lof",
    "*.lot",
    "*.nav",
    "*.out",
    "*.pdf",
    "*.snm",
    "*.toc",
    "*.vrb",
    ".*.lb",
    "*.synctex",
    "*.synctex.gz",
    "*.fdb_latexmk",
    "*.synctex(busy)",
    -- python
    "__pycache__",
}
vim.g.nvim_tree_special_files = {}
vim.g.nvim_tree_ignore = { ".git", "node_modules", ".cache" }
vim.g.nvim_tree_show_icons = { git = 0, folders = 1, files = 1, folder_arrows = 0 }
vim.g.nvim_tree_window_picker_exclude = { filetype = { "packer", "qf" }, buftype = { "terminal" } }

-- Following options are the default
require("nvim-tree").setup({
    -- disables netrw completely
    disable_netrw = true,
    -- hijack netrw window on startup
    hijack_netrw = true,
    -- open the tree when running this setup function
    open_on_setup = false,
    -- will not open on setup if the filetype is in this list
    ignore_ft_on_setup = {},
    -- closes neovim automatically when the tree is the last **WINDOW** in the view
    auto_close = true,
    -- opens the tree when changing/opening a new tab if the tree wasn't previously opened
    open_on_tab = false,
    -- hijacks new directory buffers when they are opened.
    update_to_buf_dir = {
        -- enable the feature
        enable = false,
        -- allow to open the tree if it was previously closed
        auto_open = false,
    },
    -- hijack the cursor in the tree to put it at the start of the filename
    hijack_cursor = false,
    -- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
    update_cwd = true,
    -- show lsp diagnostics in the signcolumn
    diagnostics = {
        enable = false,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    -- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
    update_focused_file = {
        -- enables the feature
        enable = true,
        -- update the root directory of the tree to the one of the folder containing the file if the file is not under the current root directory
        -- only relevant when `update_focused_file.enable` is true
        update_cwd = true,
        -- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
        -- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable` is true
        ignore_list = {},
    },
    -- configuration options for the system open command (`s` in the tree by default)
    system_open = {
        -- the command to run this, leaving nil should work in most cases
        cmd = nil,
        -- the command arguments as a list
        args = {},
    },

    view = {
        -- width of the window, can be either a number (columns) or a string in `%`, for left or right side placement
        width = 24,
        -- height of the window, can be either a number (columns) or a string in `%`, for top or bottom side placement
        height = 30,
        -- side of the tree, can be one of 'left' | 'right' | 'top' | 'bottom'
        side = "right",
        -- if true the tree will resize itself after opening a file
        auto_resize = false,
        mappings = {
            -- custom only false will merge the list with the default mappings
            -- if true, it will only use your list to set the mappings
            custom_only = false,
            -- list of mappings to set on the tree manually
            list = {},
        },
    },
})

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", opts)
