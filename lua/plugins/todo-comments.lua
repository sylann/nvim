return {
    -- Highlight comments starting with special words (TODO, FIXME, NOTE, ...)
    "folke/todo-comments.nvim",

    dependencies = { "nvim-lua/plenary.nvim" },

    event = "VimEnter",

    config = function()
        require("todo-comments").setup({
            signs = true,
            keywords = {
                FIX = { icon = " ", color = "#B267E6", alt = { "FIXME", "BUG" } },
                HACK = { icon = " ", color = "#FAAF5E",
                WARN = { icon = " ", color = "#FAAF5E", alt = { "WARNING", "XXX" } },
                NOTE = { icon = " ", color = "#A6D7F2", alt = { "HINT", "INFO" } },
                TODO = { icon = " ", color = "#AAF2A6" },
                PERF = nil,
                TEST = nil,
            },
        })
    end,
}
