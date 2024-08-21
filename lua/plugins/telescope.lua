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
                    glob = {
                        "!**/__pycache__/*",
                        "!**/.git/*",
                        "!**/target/*",
                        "!**/node_modules/*",
                    },
                    additional_args = function(opts) return { "--hidden" } end,
                },
                find_files = {
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

        -- INFO: Keymaps
        local map = Mapper({})
        map("n", "<leader><leader>", "Find Telescope builtins", builtin.builtin)
        map("n", "<leader>fr", "Resume last Telescope find results", builtin.resume)
        map("n", "<leader>hh", "Find Help", builtin.help_tags)
        map("n", "<leader>bb", "Find buffers", builtin.buffers)
        map("n", "<leader>cc", "Find commands", builtin.commands)
        map("n", "<leader>km", "Find keymaps", builtin.keymaps)
        map("n", "<leader>ft", "Find files tracked by git", builtin.git_files)
        map("n", "<leader>fh", "Find current file's git revisions", telescope.extensions.git_file_history.git_file_history)
        map("n", "<leader>ff", "Find all files in current workspace", builtin.find_files)
        map("n", "<leader>fn", "Find files in My Neovim Config", function() builtin.find_files({ cwd = vim.fn.stdpath("config") }) end)
        map("n", "<leader>fp", "Find files in Neovim installed plugins", function() builtin.find_files({ cwd = vim.fn.stdpath("data") }) end)
        map("n", "<leader>fl", "Find (Live Grep) in current workspace", builtin.live_grep)
        map("n", "<leader>fv", "Find word under cursor in current workspace", function()
            vim.cmd.normal([["vyiw]])
            builtin.live_grep({ default_text = vim.fn.getreg("v") })
        end)
        map("x", "<leader>fv", "Find visual selection in current workspace", function()
            vim.cmd.normal([["vy]])
            builtin.live_grep({ default_text = vim.fn.getreg("v") })
        end)
        map(
            "n",
            "<leader>fg",
            "List Gitmoji options",
            function()
                builtin.symbols(themes.get_dropdown({
                    sources = { "gitmoji" },
                    previewer = true,
                    silent = true,
                }))
            end
        )
    end,
}
