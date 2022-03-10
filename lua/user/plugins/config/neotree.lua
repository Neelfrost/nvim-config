require("neo-tree").setup({
    popup_border_style = "single",
    enable_git_status = true,
    enable_diagnostics = false,
    event_handlers = {
        {
            event = "vim_buffer_enter",
            handler = function()
                if vim.bo.filetype == "neo-tree" then
                    vim.cmd([[setlocal signcolumn=no]])
                end
            end,
        },
        {
            event = "file_opened",
            handler = function()
                --auto close
                require("neo-tree").close_all()
            end,
        },
        {
            event = "file_opened",
            handler = function()
                --clear search after opening a file
                require("neo-tree.sources.filesystem").reset_search()
            end,
        },
        {
            event = "file_renamed",
            handler = function(args)
                -- fix references to file
                vim.notify(args.source .. " renamed to " .. args.destination, vim.log.levels.INFO)
            end,
        },
        {
            event = "file_moved",
            handler = function(args)
                -- fix references to file
                vim.notify(args.source .. " moved to " .. args.destination, vim.log.levels.INFO)
            end,
        },
    },
    default_component_configs = {
        indent = {
            indent_size = 2,
            padding = 1,
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "IndentBlanklineChar",
        },
        icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "ﰊ",
            default_icon = "*",
        },
        name = {
            trailing_slash = false,
            use_git_status_colors = false,
        },
    },
    filesystem = {
        filters = {
            show_hidden = true,
            respect_gitignore = true,
        },
        follow_current_file = false,
        use_libuv_file_watcher = false,
        window = {
            position = "left",
            width = 24,
            mappings = {
                ["<2-LeftMouse>"] = "open",
                ["<CR>"] = "open",
                ["S"] = "open_split",
                ["s"] = "open_vsplit",
                ["C"] = "close_node",
                ["<BS>"] = "navigate_up",
                ["."] = "set_root",
                ["H"] = "toggle_hidden",
                ["I"] = "toggle_gitignore",
                ["R"] = "refresh",
                ["/"] = "filter_as_you_type",
                ["f"] = "filter_on_submit",
                ["<C-x>"] = "clear_filter",
                ["a"] = "add",
                ["d"] = "delete",
                ["r"] = "rename",
                ["c"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
            },
        },
    },
})
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<C-b>", "<cmd>NeoTreeRevealToggle!<CR>", opts)
