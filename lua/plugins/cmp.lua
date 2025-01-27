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

        ---offset: Entries prefixed with "_" will be ranked lower, and "__" even lower.
        ---Symbols prefixed with "_" are considered private by convention in many languages.
        ---@type cmp.ComparatorFunction
        local function underscore_prefixes(entry1, entry2)
            local _1, _2 = entry1.word:sub(1, 1) == "_", entry2.word:sub(1, 1) == "_"
            if _1 ~= _2 then return _2 end
            if _1 then
                local __1, __2 = entry1.word:sub(2, 2) == "_", entry2.word:sub(2, 2) == "_"
                if __1 ~= __2 then return __2 end
            end

            return nil
        end

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
                ["<C-Space>"] = cmp.mapping.complete({}),
            }),

            sorting = {
                priority_weight = 2,
                comparators = {
                    underscore_prefixes,
                    cmp.config.compare.offset,
                    -- cmp.config.compare.exact,
                    cmp.config.compare.scopes,
                    cmp.config.compare.score,
                    -- cmp.config.compare.recently_used,
                    cmp.config.compare.locality,
                    cmp.config.compare.kind,
                    -- cmp.config.compare.sort_text,
                    cmp.config.compare.length,
                    cmp.config.compare.order,
                },
            },

            sources = {
                { name = "nvim_lsp" },
                { name = "path" },
                { name = "snippy" },
            },
        })
    end,
}
