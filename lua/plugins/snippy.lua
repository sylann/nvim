return {
    -- Simple and efficient snippet engine with simple snippet declaration syntax.
    "dcampos/nvim-snippy",

    opts = {
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
