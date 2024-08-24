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

        cmp.setup({
            snippet = {
                expand = function(args) require("snippy").expand_snippet(args.body) end,
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
                ["<Enter>"] = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete({}),
            }),

            sources = {
                { name = "nvim_lsp" },
                { name = "path" },
                { name = "snippy" },
            },
        })

        local mapExpr = Mapper({ expr = true })

        mapExpr({ "i", "s" }, "<S-Tab>", "<S-Tab> navigates snippet positions in reverse if one is active", function()
            if not vim.snippet.active({ direction = -1 }) then return "<S-Tab>" end
            return "<cmd>lua vim.snippet.jump(-1)<cr>"
        end)
        mapExpr({ "i", "s" }, "<Tab>", "<Tab> navigates snippet positions if one is active", function()
            if not vim.snippet.active({ direction = 1 }) then return "<Tab>" end
            return "<cmd>lua vim.snippet.jump(1)<cr>"
        end)
    end,
}
