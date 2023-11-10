require("jaq-nvim").setup({
    cmds = {
        -- Uses vim commands
        internal = {
            lua = 'luafile "$filePath"',
            vim = 'source "$filePath"',
        },

        -- Uses shell commands
        external = {
            python = 'py -u "$filePath"',
            cs = "dotnet run",
        },
    },
    behavior = {
        -- Default type
        default = "float",
        -- Start in insert mode
        startinsert = false,
        -- Use `wincmd p` on startup
        wincmd = false,
        -- Auto-save files
        autosave = false,
    },
    ui = {
        float = {
            -- See ':h nvim_open_win'
            border = "single",
            -- See ':h winhl'
            winhl = "Normal",
            borderhl = "FloatBorder",
            -- See ':h winblend'
            winblend = 0,

            -- Num from `0-1` for measurements
            height = 0.8,
            width = 0.8,
            x = 0.5,
            y = 0.5,
        },

        terminal = {
            -- Window position
            position = "bot",
            -- Window size
            size = 15,
            -- Disable line numbers
            line_no = true,
        },

        quickfix = {
            -- Window position
            position = "bot",
            -- Window size
            size = 10,
        },
    },
})
