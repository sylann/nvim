local function setup()
    local colorizer = require("colorizer")
    colorizer.setup({ "*", "!git", "!fugitive" }, { mode = "foreground" })
    return colorizer
end

return {
    -- Add syntax color to written colors (hex, rgb, common names, ...)
    "norcalli/nvim-colorizer.lua",

    config = function()
        setup()

        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = function()
                package.loaded["colorizer"] = nil
                setup().attach_to_buffer(0)
            end,
        })
    end,
}
