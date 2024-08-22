return {
    "nvim-tree/nvim-web-devicons",

    enabled = vim.g.have_nerd_font,

    config = function()
        local devicons = require("nvim-web-devicons")
        local by_ext = devicons.get_icons_by_extension()

        devicons.setup({
            override_by_filename = {
                [".env.example"] = by_ext.env,
                [".flake8"] = by_ext.ini,
            },
        })
    end,
}
