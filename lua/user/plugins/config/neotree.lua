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
            handler = function(args)
                if args.state then
                    require("neo-tree.sources.filesystem").reset_search()
                end
            end,
        },
        {
            event = "file_renamed",
            handler = function(args)
                vim_notify(("'%s' renamed to '%s'"):format(args.source, args.destination), vim.log.levels.INFO)
            end,
        },
        {
            event = "file_moved",
            handler = function(args)
                vim_notify(("'%s' moved to '%s'"):format(args.source, args.destination), vim.log.levels.INFO)
            end,
        },
        {
            event = "file_deleted",
            handler = function(args)
                vim_notify(("'%s' deleted"):format(args), vim.log.levels.WARN)
            end,
        },
        {
            event = "file_added",
            handler = function(args)
                vim_notify(("'%s' created"):format(args), vim.log.levels.INFO)
            end,
        },
    },
    sort_function = function(a, b)
        a.ft = a.path:gsub(".+%.", "")
        b.ft = b.path:gsub(".+%.", "")

        -- Show subdirectories before files
        if a.type ~= b.type then
            return a.type ~= "file"
        end

        -- Sort by filetype, then name
        if a.ft ~= b.ft then
            return a.ft < b.ft
        elseif a.type == b.type then
            return a.path < b.path
        else
            return a.type < b.type
        end
    end,
    default_component_configs = {
        indent = {
            indent_size = 2,
            padding = 1,
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "IblIndent",
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
        follow_current_file = {
            enabled = true,
            leave_dirs_open = true,
        },
        use_libuv_file_watcher = false,
        bind_to_cwd = true,
        window = {
            position = "left",
            width = 30,
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
                ["<C-b>"] = "close_window",
                ["y"] = function(state)
                    local node = state.tree:get_node()
                    vim_notify(("Name '%s' copied to clipboard"):format(node.name), vim.log.levels.INFO)
                    vim.cmd(("let @+ = '%s'"):format(node.name))
                end,
                ["Y"] = function(state)
                    local node = state.tree:get_node()
                    vim_notify(("Path '%s' copied to clipboard"):format(node.path), vim.log.levels.INFO)
                    vim.cmd(("let @+ = '%s'"):format(node.path))
                end,
            },
        },
    },
})
