local ignored_diags = {
    80006, -- "This may be converted to an async function"
}

---@param diag vim.Diagnostic
---@return boolean
local function should_ignore_diagnostic(diag)
    return vim.tbl_contains(ignored_diags, diag.code)
end

return {
    filetypes = { "javascript", "typescript", "vue" },
    init_options = {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                languages = { "javascript", "typescript", "vue" },
            },
        },
    },
    handlers = {
        ["textDocument/publishDiagnostics"] = function(err, result, ctx)
            if result ~= nil then table.splice(result.diagnostics, should_ignore_diagnostic) end
            vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
        end,
    },
}
