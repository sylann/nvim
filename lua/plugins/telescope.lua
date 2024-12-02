return {
    -- Fuzzy Finder with rich UI capabilities
    "nvim-telescope/telescope.nvim",

    event = "VimEnter",

    branch = "0.1.x",

    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
        { "nvim-telescope/telescope-ui-select.nvim" },
        { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },

    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")
        local themes = require("telescope.themes")
        local actions = require("telescope.actions")
        local actions_layout = require("telescope.actions.layout")

        -- See `:help telescope` and `:help telescope.setup()`
        telescope.setup({
            defaults = {
                hidden = true,
                borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                -- layout_strategy = "vertical",
                layout_config = {
                    prompt_position = "top",
                    width = { padding = 3 },
                    -- preview_width = 0.5,
                    vertical = {
                        preview_position = "bottom",
                        mirror = true,
                    },
                },
                sorting_strategy = "ascending",
                mappings = {
                    n = {
                        ["@"] = actions_layout.cycle_layout_next,
                    },
                    i = {
                        ["<C-Up>"] = actions.cycle_history_prev,
                        ["<C-Down>"] = actions.cycle_history_next,
                    },
                },
            },
            pickers = {
                live_grep = {
                    glob_pattern = {
                        "!**/__pycache__/*",
                        "!**/.git/*",
                        "!**/target/*",
                        "!**/node_modules/*",
                        "!*-lock.*",
                        "!Cargo.lock",
                        "!go.sum",
                    },
                    additional_args = { "--hidden", "--multiline" },
                    -- TODO: investigate telescope bug with smart-case search:
                    -- it works but when a line contains a searched word in several case variations,
                    -- it is always the first insensitive match that gets highlighted, which can be confusing.
                },
                find_files = {
                    --stylua: ignore
                    find_command = {
                        "rg",
                        "--files",
                        "--glob", "!**/__pycache__/*",
                        "--glob", "!**/.git/*",
                        "--glob", "!**/target/*",
                        "--glob", "!**/node_modules/*",
                        "--hidden",
                        "--no-ignore",
                    },
                },
                buffers = {
                    mappings = {
                        n = {
                            ["d"] = actions.delete_buffer,
                        },
                    },
                },
                lsp_references = {
                    show_line = false,
                },
            },
            extensions = {
                ["ui-select"] = { themes.get_dropdown() },
            },
        })

        -- Enable telescope extensions, if available
        pcall(telescope.load_extension, "fzf")
        pcall(telescope.load_extension, "ui-select")
        pcall(telescope.load_extension, "git_file_history")
        local dropdown = themes.get_dropdown({
            previewer = false,
            layout_config = {
                width = 120,
                height = 30,
            },
        })

        -- INFO: Keymaps
        local map = Mapper({})
        map("n", "<leader><leader>", "Find Telescope builtins", builtin.builtin)
        map("n", "<leader>fr", "Resume last Telescope find results", builtin.resume)
        map("n", "<leader>hh", "Find Help", builtin.help_tags)
        map("n", "<leader>bb", "Find buffers", builtin.buffers)
        map("n", "<leader>cc", "Find commands", builtin.commands)
        map("n", "<leader>km", "Find keymaps", builtin.keymaps)
        map("n", "<leader>fd", "Find diagnostics", builtin.diagnostics)
        map("n", "<leader>ft", "Find files tracked by git", builtin.git_files)
        map("n", "<leader>fh", "Find current file's git revisions", telescope.extensions.git_file_history.git_file_history)
        map("n", "<leader>ff", "Find filtered files in current workspace", builtin.find_files)
        local find_files_no_ignore = function() builtin.find_files({ find_command = { "rg", "--files", "--hidden", "--no-ignore" } }) end
        map("n", "<leader>f<S-F>", "Find all files in current workspace", find_files_no_ignore)
        map("n", "<leader>fn", "Find files in My Neovim Config", function() builtin.find_files({ cwd = vim.fn.stdpath("config") }) end)
        map("n", "<leader>fp", "Find files in Neovim installed plugins", function() builtin.find_files({ cwd = vim.fn.stdpath("data") }) end)
        map("n", "<leader>fl", "Find (Live Grep) in current workspace", builtin.live_grep)
        map("n", "<leader>fo", "Find (Live Grep) in opened buffers", function() builtin.live_grep({ grep_open_files = true }) end)
        map("n", "<leader>/", "Find in current buffer", function() builtin.current_buffer_fuzzy_find(dropdown) end)
        map("n", "<leader>fv", "Find word under cursor in current workspace", function()
            vim.cmd.normal([["vyiw]])
            builtin.live_grep({ default_text = vim.fn.getreg("v") })
        end)
        map("x", "<leader>fv", "Find visual selection in current workspace", function()
            vim.cmd.normal([["vy]])
            local selection = vim.fn.getreg("v")
            -- 1. escape special symbols that will be interpreted as regex operators (not what I want)
            -- 2. live_grep uses `nvim_buf_set_lines` internally and it crashes when the prompt contains a raw newline.
            local sanitized = vim.fn.escape(selection, "/{}[]^$+*."):gsub("\n", "\\n")
            builtin.live_grep({ default_text = sanitized })
        end)
        map("i", "<C-L>j", "List Emoji options", function() builtin.symbols({ unpack(dropdown), sources = { "emoji" } }) end)
        map("i", "<C-L>g", "List Gitmoji options", function() builtin.symbols({ unpack(dropdown), sources = { "gitmoji" } }) end)
    end,
}
