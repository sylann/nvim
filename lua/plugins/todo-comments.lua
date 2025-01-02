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
                FIX = { icon = " ", color = safe(c.ui.debug), alt = { "FIXME", "BUG" } },
                HACK = { icon = " ", color = safe(c.ui.warning_light) },
                WARN = { icon = " ", color = safe(c.ui.warning_light), alt = { "WARNING", "XXX" } },
                NOTE = { icon = " ", color = safe(c.ui.hint_light), alt = { "HINT", "INFO" } },
                TODO = { icon = " ", color = safe(c.ui.success_light) },
                PERF = nil,
                TEST = nil,
            },
        })
    end,
}
