-- This plugin provides important lsp configurations for neovim lua configuration files.
-- Without it, we have basically no LSP support: no type annotations, no autocomplete, no joy.
return {
    "folke/lazydev.nvim",

    ft = "lua",

    opts = {
        -- NOTE: Because lazydev is not loading everything by default, we must make sure to manually preload
        -- some libraries to get proper lsp support.
        -- How it works:            `:help lazydev.nvim-lazydev.nvim-configuration`
        -- List possible libraries: `:lua= vim.api.nvim_get_runtime_file("", true)`
        library = {
            "~/.config/nvim",
            "lazy.nvim",
            "~/.config/nvim/after",
        },
    },
}
