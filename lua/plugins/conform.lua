return {
    -- Auto format source code
    "stevearc/conform.nvim",

    config = function()
        local conform = require("conform")

        conform.setup({
            format_on_save = nil,
            --stylua: ignore
            formatters_by_ft = {
                lua        = { "stylua",       lsp_format = "never"    },
                go         = { "gofmt",        lsp_format = "never"    },
                rust       = { "rustfmt",      lsp_format = "never"    },
                json       = { "prettier",     lsp_format = "never"    },
                javascript = { "prettier",     lsp_format = "fallback" },
                typescript = { "prettier",     lsp_format = "fallback" },
                vue        = { "prettier",     lsp_format = "fallback" },
                markdown   = { "prettier",     lsp_format = "fallback" },
                html       = { "prettier",     lsp_format = "fallback" },
                svg        = { "prettier",     lsp_format = "fallback" }
            },
        })

        local map = Mapper({})

        map("n", "gf", "Format current buffer with Conform or fallback to lsp", conform.format)
    end,
}
