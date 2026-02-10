--  INFO:  `:help lua-guide-autocommands`

local sylann_augroup = vim.api.nvim_create_augroup("SylannAuGroup", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "*",
    command = "checktime",
    group = sylann_augroup,
    desc = "On entering a buffer, check if it has been modified outside of vim.",
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    pattern = "*",
    callback = function() vim.highlight.on_yank() end,
    group = sylann_augroup,
    desc = "Highlight when yanking (copying) text",
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = { "*.env", ".env.example", "env" },
    callback = function() vim.diagnostic.enable(false) end,
    group = sylann_augroup,
    desc = "Disable LSP in env files",
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = "theme.lua",
    callback = function(args)
        local _, theme = pcall(dofile, args.file)
        if theme then theme.on_update() end
    end,
    group = sylann_augroup,
    desc = "Run theme's update function when the file named theme.lua is modified",
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = "*/lua/plugins/*.lua",
    callback = function(args)
        local has_plugin, plugin = pcall(dofile, args.file)
        if has_plugin and plugin.enabled ~= false then
            if type(plugin.config) == "function" then plugin.config(nil, plugin.opts) end
        end
    end,
    group = sylann_augroup,
    desc = "On saving a plugin file, execute its config function (if available).",
})

if vim.fn.has("wsl") then
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
        pattern = "/mnt/c/*",
        command = "set lazyredraw",
        group = sylann_augroup,
        desc = "On opening a windows file, set lazyredraw",
    })

    vim.api.nvim_create_autocmd({ "BufLeave" }, {
        pattern = "/mnt/c/*",
        command = "set nolazyredraw",
        group = sylann_augroup,
        desc = "On leaving a windows file, set nolazyredraw",
    })
end
