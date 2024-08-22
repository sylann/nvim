return {
    -- Add keyboard mappings to toggle comments
    "terrortylor/nvim-comment",

    config = function()
        local plugin = require("nvim_comment")

        plugin.setup({
            create_mappings = false,
        })

        vim.keymap.set("n", "ç", [[:CommentToggle<CR>]], { desc = "Toggle comment on current line" })
        vim.keymap.set("x", "ç", [[:'<,'>CommentToggle<CR>]], { desc = "Toggle comment on current selection" })
    end,
}
