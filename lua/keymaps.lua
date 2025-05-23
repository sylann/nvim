vim.g.mapleader = " "

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit Terminal mode and go back to normal mode in a terminal buffer" })

vim.keymap.set("n", "<leader>kk", ":Inspect<CR>", { desc = "Inspect symbol under cursor (AST / LSP)" })

vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "Reset hlsearch" })
vim.keymap.set("s", "<BS>", "><BS>", { desc = "fishy: delete selection and stay in insert mode" })

vim.keymap.set("n", "<leader>sr", ":%s/<C-R><C-W>//gc<Left><Left><Left>", { desc = "Start search and replace of word under cursor" })
vim.keymap.set("x", "<leader>sr", "y:%s/<C-R>0//gc<Left><Left><Left>", { desc = "Start search and replace of current visual selection" })
vim.keymap.set("x", "/", "y/<C-R>0<CR>N", { desc = "Search current visual selection" })

vim.keymap.set({ "n", "x" }, "<leader>d", [["_d]], { desc = "Delete current line without storing it in the copy register" })
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste currently copied text in place of the current line/selection without copying deleted text" })

vim.keymap.set({ "n", "x" }, "<leader>y", [["+y]], { desc = "[Y]ank current line to system's clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "[Y]ank current line's content to system's clipboard" })

vim.keymap.set("x", "<S-K>", ":m '<-2<CR>gv=gv", { desc = "Move current selection up" })
vim.keymap.set("x", "<S-J>", ":m '>+1<CR>gv=gv", { desc = "Move current selection down" })

vim.keymap.set("n", "<C-K>", ":cprev<CR>zz", { desc = "Move to previous Quickfix" })
vim.keymap.set("n", "<C-J>", ":cnext<CR>zz", { desc = "Move to next Quickfix" })

local function browse_at(host)
    return function() vim.ui.open(host .. vim.fn.expand("<cfile>")) end
end
vim.keymap.set("n", "gbg", browse_at("https://github.com/"), { desc = "Open filepath under cursor at github.com" })
local function browse_file_as_html()
    local filepath = "/tmp/vim-file-preview." .. vim.fn.expand("%:e")
    vim.cmd.TOhtml(filepath)
    vim.cmd.bdelete()
    local cmd = string.format("!chpa '%s' url", filepath)
    local output = vim.api.nvim_exec2(cmd, { output = true }).output
    local lines = vim.split(output, "\n", { trimempty = true })
    local url = lines[#lines]
    vim.ui.open(url)
end
vim.keymap.set("n", "gbf", browse_file_as_html, { desc = "Open filepath under cursor at github.com" })

vim.keymap.set("x", "<C-F>", ":fold<CR>", { desc = "Fold current selection" })
vim.keymap.set("n", "<C-F>", "^<S-V>f{%:fold<CR>", { desc = "Fold curly bracket scope starting on current line" })
