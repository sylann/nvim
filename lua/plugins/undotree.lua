return {
    -- History of file changes in memory (optionally on disk)
    "mbbill/undotree",

    config = function()
        local map = Mapper({})

        map("n", "<leader>u", "Toggle undo tree", vim.cmd.UndotreeToggle)
    end,
}
