return {
    "nvim-tree/nvim-tree.lua",

    dependencies = "nvim-tree/nvim-web-devicons",

    config = function()
        -- vim.g.loaded_netrw = 1
        -- vim.g.loaded_netrwPlugin = 1

        local nvim_tree = require("nvim-tree")
        local api = require("nvim-tree.api")
        nvim_tree.setup({
            sort = {
                sorter = "case_sensitive",
            },
            view = {
                width = 30,
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = true,
            },
        })

        vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree open or closed, without affecting its content" })
        vim.keymap.set("n", "µ", function ()
            api.tree.open({
                path = vim.fn.expand("%"),
                current_window = true,
                find_file = true,
                update_root = true,
            })
        end, { desc = "Open NvimTree, focus current file inside and update the root directory when current file is not inside" })

    end,
}
