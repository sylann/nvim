return {
    "tpope/vim-fugitive",

    config = function()
        local map = Mapper({})

        map("n", "<C-s>g", "Open fugitive in a vertical Split", ":vertical Git<CR>")
    end,
}
