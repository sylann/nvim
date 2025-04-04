return {
    -- Highlight comments starting with special words (TODO, FIXME, NOTE, ...)
    "folke/todo-comments.nvim",

    dependencies = { "nvim-lua/plenary.nvim" },

    event = "VimEnter",

    config = function()
        local todo = require("todo-comments")
        todo.setup({
            merge_keywords = false, -- prevent the lib from declaring its defaults
            signs = true,
            keywords = {
                TODO = { icon = " ", color = "todo" },
                FIXME = { icon = " ", color = "fix", alt = { "FIX" } },
                HACK = { icon = " ", color = "hack", alt = { "XXX" } },
                WARN = { icon = " ", color = "warn", alt = { "WARNING" } },
                INFO = { icon = " ", color = "info" },
                HINT = { icon = " ", color = "hint", alt = { "NOTE" } },
            },
            colors = {
                todo = { "CommentSuccess" },
                fix = { "Debug" },
                hack = { "#FF7744" },
                warn = { "CommentWarning" },
                info = { "CommentInfo" },
                hint = { "CommentHint" },
            },
        })

        vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "Search todo-comments in the current workspace" })
    end,
}
