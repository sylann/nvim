return {
    -- Add syntax color to written colors (hex, rgb, common names, ...)
    "norcalli/nvim-colorizer.lua",

    config = function()
        require("colorizer").setup({ "*" }, { mode = "foreground" })

        vim.keymap.set("n", "<leader>co", vim.cmd.ColorizerToggle)
    end,
}
