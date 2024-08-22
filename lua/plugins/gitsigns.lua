return {
    -- Git features
    "lewis6991/gitsigns.nvim",

    config = function()
        local gitsigns = require("gitsigns")
        gitsigns.setup {
            signs_staged_enable = true,
            signcolumn          = true,
            word_diff           = false, -- nice one to toggle at will
            attach_to_untracked = false, -- to test
            current_line_blame  = true,
            max_file_length     = 5000,

            signs               = {
                add          = { text = '+' },
                change       = { text = '~' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '#' },
                untracked    = { text = '┆' },
            },
            signs_staged        = {
                add          = { text = '┃' },
                change       = { text = '┃' },
                delete       = { text = '┻' },
                topdelete    = { text = '┳' },
                changedelete = { text = '╋' },
                untracked    = { text = '╏' },
            },

            on_attach           = function(buffer)
                local map = Mapper { buffer = buffer }
                local mapExpr = Mapper { buffer = buffer, expr = true }

                map("n", "<C-s>s", "Stage hunk under cursor", gitsigns.stage_hunk)
                map("n", "<C-s>r", "Reset hunk under cursor", gitsigns.reset_hunk)
                map("x", "<C-s>s", "Stage hunk(s) in current selection", function()
                    gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') }
                end)
                map("x", "<C-s>s", "Reset hunk(s) in current selection", function()
                    gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
                end)
                map("x", "<C-s>u", "Reset hunk under cursor", gitsigns.reset_hunk)
                map("n", "<C-s>S", "Stage whole buffer", gitsigns.stage_buffer)
                map("n", "<C-s>U", "Reset whole buffer", gitsigns.reset_buffer)

                map("n", "<C-s>v", "Preview hunk under cursor", gitsigns.preview_hunk)
                map("n", "<C-s>b", "Show diff of last commit on current line", function()
                    gitsigns.blame_line { full = true }
                end)

                map("n", "<C-s>d", "Diff current file index", gitsigns.diffthis)
                map("n", "<C-s>D", "Diff current file with head", function() gitsigns.diffthis('~') end)

                mapExpr({ "n", "x" }, "<C-s>k", "Jump to previous hunk", function()
                    if vim.wo.diff then return "[c" end
                    vim.schedule(gitsigns.prev_hunk)
                    return "<Ignore>"
                end)

                mapExpr({ "n", "x" }, "<C-s>j", "Jump to next hunk", function()
                    if vim.wo.diff then return "]c" end
                    vim.schedule(gitsigns.next_hunk)
                    return "<Ignore>"
                end)
            end
        }
    end,
}
