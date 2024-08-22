vim.g.mapleader = " "

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>",  { desc = "Exit Terminal mode and go back to normal mode in a terminal buffer" })

vim.keymap.set("n", "<leader>kk", ":Inspect<CR>", { desc = "Inspect symbol under cursor (AST / LSP)" })

vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "Reset hlsearch" })
vim.keymap.set("n", "<leader>sr", ":%s/<C-R><C-W>//gc<Left><Left><Left>", { desc = "Start search and replace of word under cursor" })
vim.keymap.set("x", "<leader>sr", "y:%s/<C-R>0//gc<Left><Left><Left>", { desc = "Start search and replace of current visual selection" })
vim.keymap.set("x", "/", "y/<C-R>0<CR>N", { desc = "Search current visual selection" })

vim.keymap.set({ "n", "x" }, "<leader>d", [["_d]], { desc = "Delete current line without storing it in the copy register" })
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste currently copied text in place of the current line/selection without copying deleted text" })

vim.keymap.set({ "n", "x" }, "<leader>y", [["+y]], { desc = "[Y]ank current line to system's clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "[Y]ank current line's content to system's clipboard" })

vim.keymap.set("x", "↑", ":m '<-2<CR>gv=gv", { desc = "Move current selection up" })
vim.keymap.set("x", "↓", ":m '>+1<CR>gv=gv", { desc = "Move current selection down" })

vim.keymap.set("n", "<C-K>", ":cprev<CR>zz", { desc = "Move to previous Quickfix" })
vim.keymap.set("n", "<C-J>", ":cnext<CR>zz", { desc = "Move to next Quickfix" })

vim.keymap.set("n", "<C-F>", "vi{:fold<CR>", { desc = "Fold current block" })
