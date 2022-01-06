local actions = require("telescope.actions")
local custom_config = require("user.plugins.custom.telescope")
local telescope = require("telescope")

telescope.setup({
    defaults = {
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
        },
        layout_config = {
            horizontal = {
                mirror = false,
            },
            vertical = {
                mirror = false,
            },
        },
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        border = true,
        use_less = true,
        color_devicons = true,
        winblend = 0,
        entry_prefix = "  ",
        prompt_prefix = "❯ ",
        selection_caret = "❯ ",
        initial_mode = "insert",
        scroll_strategy = "cycle",
        path_display = { "smart" },
        selection_strategy = "reset",
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
        set_env = { COLORTERM = "truecolor" },
        file_ignore_patterns = { ".git", "tags" },
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        mappings = {
            i = {
                ["<C-n>"] = false,
                ["<C-p>"] = false,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<Esc>"] = actions.close,
            },
            n = {
                ["<C-n>"] = false,
                ["<C-p>"] = false,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            },
        },
    },
    pickers = {
        find_files = custom_config.dropdown(),
        oldfiles = custom_config.dropdown({ prompt_title = "Recent Files" }),
        git_files = custom_config.dropdown(),
    },
    extensions = {
        frecency = {
            show_scores = false,
            show_unindexed = false,
            ignore_patterns = { "*.git/*" },
        },
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "ignore_case",
        },
    },
})

-- Load extensions
local extensions = { "ultisnips", "fzf", "sessions" }
pcall(function()
    for _, ext in ipairs(extensions) do
        telescope.load_extension(ext)
    end
end)

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "tr", "<cmd>lua require('user.plugins.custom.telescope').frecency()<CR>", opts)
vim.api.nvim_set_keymap("n", "tf", "<cmd>lua require('user.plugins.custom.telescope').git_or_find()<CR>", opts)
vim.api.nvim_set_keymap("n", "tp", "<cmd>lua require('user.plugins.custom.telescope').dir_python()<CR>", opts)
vim.api.nvim_set_keymap("n", "tn", "<cmd>lua require('user.plugins.custom.telescope').dir_nvim()<CR>", opts)
vim.api.nvim_set_keymap("n", "tl", "<cmd>lua require('user.plugins.custom.telescope').dir_latex()<CR>", opts)
vim.api.nvim_set_keymap("n", "ts", "<cmd>lua require('user.plugins.custom.telescope').sessions()<CR>", opts)
vim.api.nvim_set_keymap("n", "<F5>", "<cmd>lua require('user.plugins.custom.telescope').reload_modules()<CR>", opts)
