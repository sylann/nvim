return {
    "ThePrimeagen/harpoon",

    branch = "harpoon2",

    dependencies = { "nvim-lua/plenary.nvim" },

    config = function()
        local harpoon = require("harpoon")

        harpoon:setup({})

        vim.keymap.set("n", "<leader>_", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        vim.keymap.set("n", "<leader>=", function() harpoon:list():add() end)

        vim.keymap.set("n", "<leader>&", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<leader>é", function() harpoon:list():select(2) end)
        vim.keymap.set("n", '<leader>"', function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<leader>'", function() harpoon:list():select(4) end)
        vim.keymap.set("n", "<leader>|", function() harpoon:list():select(5) end)
        vim.keymap.set("n", "<leader>ù", function() harpoon:list():select(6) end)
    end,
}
