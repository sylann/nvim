return {
    -- Show sticky parent scopes (class, function, if, for, ...)
    --   When parent scopes start beyond currently visible lines,
    --   this plugin shows them as virtual lines floating at the screen top.
    "nvim-treesitter/nvim-treesitter-context",

    opts = {
        max_lines = 10,
        multiline_threshold = 1,
    },
}
