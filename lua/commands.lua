-- vim.api.nvim_create_user_command("NAME", [[:COMMAND<CR>]], { desc = "DESCRIPTION" })

vim.api.nvim_create_user_command("CopyFileName", [[let @+ = expand("%:t")]], { desc = "Copy file name to clipboard" })
vim.api.nvim_create_user_command("CopyFileStem", [[let @+ = expand("%:t:r")]], { desc = "Copy file stem to clipboard" })
vim.api.nvim_create_user_command("CopyRelPath", [[let @+ = expand("%")]], { desc = "Copy file relative path to clipboard" })
vim.api.nvim_create_user_command("CopyAbsPath", [[let @+ = expand("%:p")]], { desc = "Copy file absolute path to clipboard" })
vim.api.nvim_create_user_command("CopyParentName", [[let @+ = expand("%:h:t")]], { desc = "Copy parent dir name to clipboard" })
vim.api.nvim_create_user_command("CopyParentRelPath", [[let @+ = expand("%:h")]], { desc = "Copy parent dir relative path to clipboard" })
vim.api.nvim_create_user_command("CopyParentAbsPath", [[let @+ = expand("%:p:h")]], { desc = "Copy parent dir absolute path to clipboard" })

vim.api.nvim_create_user_command("CdCurrentFileParent", [[lcd %:p:h]], { desc = "Change nvim working directory to current file's directory" })

vim.api.nvim_create_user_command("MakeExecutable", [[!chmod u+x %:p]], { desc = "Make current file executable for the user" })

vim.api.nvim_create_user_command("CC", [[!clang % -o out && { ./out; rm ./out; }]], { desc = "Compile current file with Clang" })
vim.api.nvim_create_user_command("CompileCpp14", [[!c++ -std=c++14 % -o %:r]], { desc = "Compile current file with Clang C++14" })
vim.api.nvim_create_user_command("CompileCpp17", [[!c++ -std=c++17 % -o %:r]], { desc = "Compile current file with Clang C++17" })
vim.api.nvim_create_user_command("CompileCpp20", [[!c++ -std=c++20 % -o %:r]], { desc = "Compile current file with Clang C++20" })
