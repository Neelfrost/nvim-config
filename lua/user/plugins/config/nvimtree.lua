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
vim.g.nvim_tree_special_files = {}
vim.g.nvim_tree_show_icons = { git = 0, folders = 1, files = 1, folder_arrows = 0 }
vim.g.nvim_tree_window_picker_exclude = { filetype = { "packer", "qf" }, buftype = { "terminal" } }

require("nvim-tree").setup({
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = false,
    auto_close = true,
    open_on_tab = false,
    hijack_cursor = true,
    update_cwd = true,
    ignore_ft_on_setup = {},
    update_to_buf_dir = {
        enable = false,
        auto_open = false,
    },
    diagnostics = {
        enable = false,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = {},
    },
    system_open = {
        cmd = nil,
        args = {},
    },
    filters = {
        dotfiles = false,
        custom = {},
    },
    git = {
        enable = true,
        ignore = true,
        timeout = 500,
    },
    view = {
        width = 24,
        height = 30,
        hide_root_folder = false,
        side = "left",
        auto_resize = false,
        mappings = {
            custom_only = false,
            list = {},
        },
        number = false,
        relativenumber = false,
    },
    trash = {
        cmd = "trash",
        require_confirm = true,
    },
})

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", opts)
