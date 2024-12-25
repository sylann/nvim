return {
    -- Simple and efficient snippet engine with simple snippet declaration syntax.
    "dcampos/nvim-snippy",

    opts = {
        scopes = {
            typescript = { '_', 'javascript', 'typescript' },
            vue = { '_', 'vue', 'html', 'css', 'javascript', 'typescript' },
        },
        mappings = {
            is = {
                ["<Tab>"] = "expand_or_advance",
                ["<S-Tab>"] = "previous",
            },
        },
        hl_group = "SnippyPlaceholder",
        virtual_markers = {
            enabled = true,
            hl_group = "SnippyMarker",
        },
    },
}
