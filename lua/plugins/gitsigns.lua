return {
    -- Git features
    "lewis6991/gitsigns.nvim",

    config = function()
        local gitsigns = require("gitsigns")
        local actions = require("gitsigns.actions")
        gitsigns.setup({
            signs_staged_enable = true,
            signcolumn = true,
            word_diff = false, -- nice one to toggle at will
            attach_to_untracked = false, -- to test
            current_line_blame = true,
            max_file_length = 5000,

            -- stylua: ignore
            signs = {
                add          = { text = "+" },
                change       = { text = "~" },
                delete       = { text = "_" },
                topdelete    = { text = "‾" },
                changedelete = { text = "#" },
                untracked    = { text = "┆" },
            },
            -- stylua: ignore
            signs_staged = {
                add          = { text = "┃" },
                change       = { text = "┃" },
                delete       = { text = "┻" },
                topdelete    = { text = "┳" },
                changedelete = { text = "╋" },
                untracked    = { text = "╏" },
            },

            on_attach = function(buffer)
                local map = Mapper({ buffer = buffer })

                map("n", "<C-s>S", "Stage whole buffer", actions.stage_buffer)
                map("n", "<C-s>s", "Stage hunk under cursor", actions.stage_hunk)
                map("x", "<C-s>s", "Stage hunk(s) in current selection", function() actions.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
                map("n", "<C-s>U", "Unstage whole buffer", actions.reset_buffer)
                map("n", "<C-s>u", "Unstage hunk under cursor", actions.reset_hunk)
                map("x", "<C-s>u", "Unstage hunk(s) in current selection", function() actions.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)

                map("n", "<C-s>r", "Revert last stage hunk", actions.undo_stage_hunk)

                map("n", "<C-s>v", "Preview hunk under cursor", actions.preview_hunk)
                map("n", "<C-s>b", "Show diff of last commit on current line", function() actions.blame_line({ full = true }) end)

                map("n", "<C-s>d", "Diff current file index", actions.diffthis)
                map("n", "<C-s>D", "Diff current file with head", function() actions.diffthis("~") end)

                map("n", "<C-s>k", "Jump to previous hunk", function() actions.nav_hunk("prev") end)
                map("n", "<C-s>j", "Jump to next hunk", function() actions.nav_hunk("next") end)
            end,
        })
    end,
}
