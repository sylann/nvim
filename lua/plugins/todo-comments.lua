return {
    -- Highlight comments starting with special words (TODO, FIXME, NOTE, ...)
    "folke/todo-comments.nvim",

    dependencies = { "nvim-lua/plenary.nvim" },

    event = "VimEnter",

    config = function()
        local c = require("theme").colors

        local safe = function(color) return color or error("missing color definition", 2) end
        require("todo-comments").setup({
            signs = true,
            keywords = {
                FIX = { icon = " ", color = safe(c.util.debug), alt = { "FIXME", "BUG" } },
                HACK = { icon = " ", color = safe(c.util.warning_100) },
                WARN = { icon = " ", color = safe(c.util.warning_100), alt = { "WARNING", "XXX" } },
                NOTE = { icon = " ", color = safe(c.util.hint_100), alt = { "HINT", "INFO" } },
                TODO = { icon = " ", color = safe(c.util.success_100) },
                PERF = nil,
                TEST = nil,
            },
        })
    end,
}
