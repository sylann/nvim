return {
    -- Enable and configure autocompletion features
    "hrsh7th/nvim-cmp",

    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
    },

    event = "InsertEnter",

    config = function()
        local cmp = require "cmp"
        local icon_by_kind = require("icons").icon_by_symbol_kind

        cmp.setup {
            snippet = {
                expand = function(args)
                    vim.snippet.expand(args.body)
                end,
            },
            formatting = {
                fields = { "abbr", "kind", "menu" },
                format = function(_, vim_item)
                    local k = vim_item.kind
                    local ic = icon_by_kind[k] or ''
                    vim_item.kind = ic and " " .. ic .. " " .. k or k
                    return vim_item
                end,
            },

            -- INFO: `:help ins-completion`
            mapping = cmp.mapping.preset.insert {
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<Enter>"] = cmp.mapping.confirm { select = true },
                ["<Tab>"] = cmp.mapping.confirm { select = true },
                ["<C-Space>"] = cmp.mapping.complete {},
            },

            sources = {
                { name = "nvim_lsp" },
                { name = "path" },
            },
        }

        vim.keymap.set({ "i", "s" }, "<Tab>", function()
            if vim.snippet.active({ direction = 1 }) then
                return "<cmd>lua vim.snippet.jump(1)<cr>"
            end
            return "<Tab>"
        end, { expr = true })
    end,
}
