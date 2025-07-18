-- nvim-lspconfig provides working LSP configuration defaults for most commonly used languages.
-- It is not really needed for LSP to work since NVIM now has builtin lsp support.

-- INFO: If the defaults are not enough for a language, add a file at `<root>/after/lsp/<server_name>.lua`.
-- It should return the configuration table or a list of tables to merge.
-- The server name is specific because we want to reuse the predefined configurations but it is otherwise insignificant.
-- Use `:help lspconfig-all` to search these ids.

return {
    "neovim/nvim-lspconfig",

    config = function()
        local global_capabilities = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            -- INFO: Add LSP extensions below
            require("cmp_nvim_lsp").default_capabilities()
        )
        vim.lsp.config("*", global_capabilities)

        -- XXX: Enable whatever LSP plugins are installed with Mason.
        -- Not pretty but does the trick for now (I don't want to maintain a list of LSP names).
        local registry = require("mason-registry")
        for _, package in ipairs(registry.get_all_package_specs()) do
            if registry.is_installed(package.name) and vim.tbl_contains(package.categories, "LSP") then
                local server_name, _ = string.gsub(package.name, '-', '_')
                server_name, _ = string.gsub(server_name, '_lsp$', '')
                server_name, _ = string.gsub(server_name, '_language_server$', '_ls')
                server_name, _ = string.gsub(server_name, '^typescript', 'ts')
                -- print(string.format("  %s (%s)", server_name, package.name))
                vim.lsp.enable(server_name)
            end
        end

        local function custom_lsp_definitions()
            -- WTF is this customization API?
            local entry_display = require("telescope.pickers.entry_display")
            local displayer = entry_display.create({ items = { { remaining = true } } })
            local display = function(entry) return displayer({ CleanFilename(entry.filename) .. ":" .. entry.lnum }) end
            require("telescope.builtin").lsp_definitions({
                entry_index = { display = function() return display, true end },
            })
        end

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
            callback = function(event)
                local map = Mapper({ buffer = event.buf, remap = false })

                local tesc = require("telescope.builtin")

                -- TODO: only enable supported features (use client:supports_method)
                -- see https://neovim.io/doc/user/lsp.html#lsp-config

                -- See `:help vim.lsp.*` for documentation on any of the below functions
                map("n", "K", "[LSP] Show symbol description on hover", vim.lsp.buf.hover)
                map("i", "<C-x>", "[LSP] Show current function's signature", vim.lsp.buf.signature_help)
                map("n", "gd", "[LSP] Go to definition", custom_lsp_definitions)
                map("n", "gD", "[LSP] Go to declaration", vim.lsp.buf.declaration)
                map("n", "gr", "[LSP] Go to references", tesc.lsp_references)
                map("n", "gt", "[LSP] Go to type definition", tesc.lsp_type_definitions)
                map("n", "gi", "[LSP] Go to implementation", vim.lsp.buf.implementation)
                map("n", "gk", "[LSP] Go to previous diagnostic", function() vim.diagnostic.jump({ count = -1 }) end)
                map("n", "gj", "[LSP] Go to next diagnostic", function() vim.diagnostic.jump({ count = 1 }) end)
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
    end,
}
