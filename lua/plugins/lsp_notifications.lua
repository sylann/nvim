return {
    -- Displays LSP status messages in the bottom right corner of the window.
    "j-hui/fidget.nvim",

    config = function()
        require("fidget").setup({
            progress = {
                display = {
                    done_style = "Constant",
                    progress_style = "WarningMsg",
                    group_style = "Title",
                    icon_style = "Question",
                },
            },
            notification = {
                view = {
                    group_separator_hl = "Comment",
                },
                window = {
                    border = "solid",
                    normal_hl = "Comment",
                },
            },
        })
    end,
}
