local custom_lsp_definitions = function()
    -- WTF is this customization API?
    local entry_display = require("telescope.pickers.entry_display")
    local displayer = entry_display.create({ items = { { remaining = true } } })
    local display = function(entry) return displayer({ CleanFilename(entry.filename) .. ":" .. entry.lnum }) end
    require("telescope.builtin").lsp_definitions({
        entry_index = { display = function() return display, true end }
    })
end

return {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",

    dependencies = {
        -- Automatically install LSPs and related tools to stdpath for neovim
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",

        -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        { "folke/neodev.nvim", opts = {} },
    },

    config = function()
        --  INFO   :help lsp-vs-treesitter

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
            callback = function(event)
                local map = Mapper({ buffer = event.buf, remap = false })

                local tesc = require("telescope.builtin")

                -- See `:help vim.lsp.*` for documentation on any of the below functions
                map("n", "K", "[LSP] Show symbol description on hover", vim.lsp.buf.hover)
                map("i", "<C-x>", "[LSP] Show current function's signature", vim.lsp.buf.signature_help)
                map("n", "gd", "[LSP] Go to definition", custom_lsp_definitions)
                map("n", "gD", "[LSP] Go to declaration", vim.lsp.buf.declaration)
                map("n", "gr", "[LSP] Go to references", tesc.lsp_references)
                map("n", "gt", "[LSP] Go to type definition", tesc.lsp_type_definitions)
                map("n", "gi", "[LSP] Go to implementation", vim.lsp.buf.implementation)
                map("n", "gk", "[LSP] Go to previous diagnostic", vim.diagnostic.goto_prev)
                map("n", "gj", "[LSP] Go to next diagnostic", vim.diagnostic.goto_next)
                -- map("n", "gf", "[LSP] Autoformat current buffer", vim.lsp.buf.format) -- let conform handle formatting
                map("n", "gn", "[LSP] Rename symbol", vim.lsp.buf.rename)
                map({ "n", "x" }, "ga", "[LSP] Show code actions", vim.lsp.buf.code_action)
                map("i", "<C-g>", "[LSP] Show code actions", vim.lsp.buf.code_action)

                local client = vim.lsp.get_client_by_id(event.data.client_id)

                if client and client.server_capabilities.documentHighlightProvider then
                    -- Auto highlight all occurences of symbol under cursor (after not moving for a while)
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    -- Auto unhighlight symbol under cursor after moving
                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
            end,
        })

        -- LSP servers and clients are able to communicate to each other what features they support.
        --  By default, Neovim doesn't support everything that is in the LSP Specification.
        --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
        --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
        local capabilities = vim.lsp.protocol.make_client_capabilities()

        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

        --[[
        --  Add any additional override configuration in the following tables.
        --  This allows initialization and auto installation in a single declaration.
        --
        --  Each entry is equivalent to calling `require("lspconfig").<server>.setup`.
        --  For example:
        --    clangd = {}   <=>   require("lspconfig").clangd.setup({})
        --
        --  Available keys:
        --  - cmd (table): Override the default command used to start the server
        --  - filetypes (table): Override the default list of associated filetypes for the server
        --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
        --  - settings (table): Override the default settings passed when initializing the server.
        --
        --  For example, to see the options for `lua_ls`,
        --  you could go to: https://luals.github.io/wiki/settings/
        --
        --  See `:help lspconfig-all` for the list of pre-configured LSPs
        --]]
        local servers = {
            clangd = {},
            gopls = {},
            -- pyright = {},
            ruff = {},
            rust_analyzer = {},
            -- INFO: possible alternative: https://github.com/pmizio/typescript-tools.nvim
            ts_ls = {
                init_options = {
                    plugins = {
                        {
                            name = "@vue/typescript-plugin",
                            location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                            languages = { "javascript", "typescript", "vue" },
                        },
                    },
                },
                filetypes = { "javascript", "typescript", "vue" },
                handlers = {
                    ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
                        if result ~= nil then
                            table.splice(result.diagnostics, function(diag)
                                return diag.code == 80006 -- "This may be converted to an async function"
                            end)
                        end
                        vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
                    end,
                },
            },
            volar = {},
            angularls = {
                filetypes = { "typescript", "html", "htmlangular" },
            },

            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                            -- `missing-fields` warning is especially annoying on setup({}) calls inside of config()
                            disable = { "missing-fields" },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                        completion = {
                            callSnippet = "Replace",
                        },
                    },
                },
            },
        }

        -- Ensure servers and tools above are installed
        require("mason").setup()

        local ensure_installed = vim.tbl_keys(servers or {})

        vim.list_extend(ensure_installed, {
            "stylua",
        })

        require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

        require("mason-lspconfig").setup({
            handlers = {
                function(server_name)
                    -- Override default capabilities with server's specific capabilities
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                    require("lspconfig")[server_name].setup(server)
                end,
            },
        })
    end,
}
