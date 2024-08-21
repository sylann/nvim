return {
    "stevearc/oil.nvim",

    dependencies = "nvim-tree/nvim-web-devicons",

    config = function()
        local oil = require("oil")
        local actions = require("oil.actions")

        oil.setup({
            columns = { "icon", "permissions", "size" },

            delete_to_trash = true,

            view_options = {
                show_hidden = false,
                is_hidden_file = function(name)
                    -- INFO: adapt logic to ignore useless files
                    return name == ".DS_Store" or vim.endswith(name, ".pyc")
                end,
            },

            -- INFO: Keymaps — Only from within Oil
            keymaps = {
                ["g?"] = actions.show_help,
                ["<CR>"] = actions.select,
                ["<C-s>"] = actions.select_vsplit,
                ["<C-h>"] = actions.select_split,
                ["<C-t>"] = actions.select_tab,
                ["<C-p>"] = actions.preview,
                ["<C-c>"] = actions.close,
                ["<C-l>"] = actions.refresh,
                ["<BS>"] = actions.parent,
                ["_"] = actions.open_cwd,
                ["-"] = actions.cd,
                ["gs"] = actions.change_sort,
                ["gx"] = actions.open_external,
                ["g."] = actions.toggle_hidden,
                ["gt"] = actions.toggle_trash,
            },
        })

        -- INFO: Keymaps
        local map = Mapper({})

        map("n", "<BS>", "Open parent directory", "<CMD>Oil<CR>")
    end,
}
