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
                require("neo-tree").close_all()
            end,
        },
        {
            event = "file_opened",
            handler = function()
                require("neo-tree.sources.filesystem").reset_search()
            end,
        },
        {
            event = "file_renamed",
            handler = function(args)
                vim.notify(("'%s' renamed to '%s'"):format(args.source, args.destination), vim.log.levels.INFO)
            end,
        },
        {
            event = "file_moved",
            handler = function(args)
                vim.notify(("'%s' moved to '%s'"):format(args.source, args.destination), vim.log.levels.INFO)
            end,
        },
        {
            event = "file_deleted",
            handler = function(args)
                vim.notify(("'%s' deleted"):format(args), vim.log.levels.INFO)
            end,
        },
        {
            event = "file_added",
            handler = function(args)
                vim.notify(("'%s' created"):format(args), vim.log.levels.INFO)
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
        git_status = {
            symbols = {
                -- Change type
                added = "",
                deleted = "",
                modified = "",
                renamed = "",
                -- Status type
                untracked = "",
                ignored = " ",
                unstaged = " ",
                staged = " ",
                conflict = " ",
            },
        },
    },
    filesystem = {
        filtered_items = {
            visible = false,
            hide_dotfiles = true,
            hide_gitignored = true,
            hide_by_name = {},
            never_show = {},
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
                ["A"] = "add_directory",
                ["d"] = "delete",
                ["r"] = "rename",
                ["c"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
                ["q"] = "close_window",
                ["y"] = function(state)
                    local node = state.tree:get_node()
                    vim.notify(("Name '%s' copied to clipboard"):format(node.name), vim.log.levels.INFO)
                    vim.cmd(("let @+ = '%s'"):format(node.name))
                end,
                ["Y"] = function(state)
                    local node = state.tree:get_node()
                    vim.notify(("Path '%s' copied to clipboard"):format(node.path), vim.log.levels.INFO)
                    vim.cmd(("let @+ = '%s'"):format(node.path))
                end,
            },
        },
    },
})

local map = vim.keymap.set
local opts = { silent = true }

map("n", "<C-b>", "<cmd>Neotree source=filesystem toggle=true dir=%:p:h<CR>", opts)
