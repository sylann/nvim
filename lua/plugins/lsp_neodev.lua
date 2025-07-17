-- This plugin provides important lsp configurations for neovim lua configuration files.
-- Without it, we have basically no LSP support: no type annotations, no autocomplete, no joy.
-- NOTE: The newer plugin `folke/lazydev.nvim` causes too many problems (will need more time to figure things out)
return {
    "folke/neodev.nvim",

    opts = {},
}
