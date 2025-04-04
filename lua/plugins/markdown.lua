return {
    {
        "iamcco/markdown-preview.nvim",

        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = ":call mkdp#util#install()",
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",

        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },

        enabled = false,

        config = function()
            require("render-markdown").setup({
                bullet = { left_pad = 1 },
                code = { width = "block", min_width = 60 },
                heading = { enabled = true, position = "inline", backgrounds = {} },
                sign = { enabled = false },
            })
        end,
    },
}
