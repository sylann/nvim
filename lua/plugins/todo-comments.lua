return {
    -- Highlight comments starting with special words (TODO, FIXME, NOTE, ...)
    "folke/todo-comments.nvim",

    dependencies = { "nvim-lua/plenary.nvim" },

    event = "VimEnter",

    config = function()
        require("todo-comments").setup({
            signs = true,
            keywords = {
                FIX = { icon = " ", color = "debug", alt = { "FIXME", "BUG" } },
                HACK = { icon = " ", color = "warning_100" },
                WARN = { icon = " ", color = "warning_100", alt = { "WARNING", "XXX" } },
                NOTE = { icon = " ", color = "hint_100", alt = { "HINT", "INFO" } },
                TODO = { icon = " ", color = "success_100" },
                PERF = nil,
                TEST = nil,
            },
            colors = require("theme").colors.util,
        })
    end,
}
