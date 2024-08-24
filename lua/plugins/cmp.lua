return {
    -- Enable and configure autocompletion features
    "hrsh7th/nvim-cmp",

    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "dcampos/nvim-snippy",
        "dcampos/cmp-snippy",
    },

    event = "InsertEnter",

    config = function()
        local cmp = require("cmp")
        local icon_by_kind = require("icons").icon_by_symbol_kind
        local snippy = require("snippy")

        cmp.setup({
            snippet = {
                expand = function(args) snippy.expand_snippet(args.body) end,
            },
            formatting = {
                fields = { "abbr", "kind", "menu" },
                format = function(_, vim_item)
                    local k = vim_item.kind
                    local ic = icon_by_kind[k] or ""
                    vim_item.kind = ic and " " .. ic .. " " .. k or k
                    return vim_item
                end,
            },

            -- INFO: `:help ins-completion`
            mapping = cmp.mapping.preset.insert({
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                ["<Enter>"] = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete({}),
                ["<C-;>"] = cmp.mapping(function(fb) return snippy.can_expand_or_advance() and snippy.expand_or_advance() or fb() end, { "i", "s" }),
                ["<C-,>"] = cmp.mapping(function(fb) return snippy.can_jump(-1) and snippy.previous() or fb() end, { "i", "s" }),
            }),

            sources = {
                { name = "nvim_lsp" },
                { name = "path" },
                { name = "snippy" },
            },
        })
    end,
}
