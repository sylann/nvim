local function del_qf_item()
    local items = vim.fn.getqflist()
    local start_lnum, _, end_lnum, _ = GetVisualSelectionBoundary()
    table.splice(items, function (_, idx) return idx >= start_lnum and idx <= end_lnum end)
    vim.fn.setqflist(items, "r")
    if #items == 0 then return end
    local line = vim.fn.min({start_lnum, #items})
    vim.api.nvim_win_set_cursor(0, { line, 0 })
end

local function setup_qf_actions()
    vim.keymap.set("n", "d", del_qf_item, { silent = true, buffer = 0 })
    vim.keymap.set("x", "d", del_qf_item, { silent = true, buffer = 0 })
    vim.keymap.set("n", "<Tab>", "<Enter>:copen<CR>", { silent = true, buffer = 0 })
end

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "qf",
    callback = setup_qf_actions,
    group = "SylannAuGroup",
    desc = "Setup quickfix list keymaps",
})
