-- Mason allows easy installation of LSP tools, as well as autoformatters, linters and debuggers.
return {
    "williamboman/mason.nvim",

    dependencies = {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },

    config = function()
        require("mason").setup()
        require("mason-tool-installer").setup({ ensure_installed = { "stylua" } })
    end,
}
