local function yank_entry_path(regname)
    return function()
        local oilpath = vim.api.nvim_buf_get_name(0)
        local oil_prefix = "oil://"

        if not oilpath:starts_with(oil_prefix) then
            vim.notify(string.format("Unexpected Oil path: %s", oilpath), vim.log.levels.ERROR)
            return
        end

        local ws_prefix = vim.fn.getcwd()

        -- Try path relative to workspace, fallback to absolute path
        local prefix = oil_prefix .. ws_prefix .. "/"
        if not oilpath:starts_with(prefix) then prefix = oil_prefix end

        -- Contruct path of entry
        local dir_path = string.sub(oilpath, #prefix + 1)
        local entry_name = require("oil").get_cursor_entry().name
        local entry_path = dir_path .. entry_name

        vim.notify(entry_path, vim.log.levels.INFO)
        vim.fn.setreg(regname, entry_path)
    end
end

return {
    "stevearc/oil.nvim",
    enabled = true,

    dependencies = "nvim-tree/nvim-web-devicons",

    config = function()
        local oil = require("oil")
        local actions = require("oil.actions")

        oil.setup({
            columns = { "icon", "permissions", "size" },

            delete_to_trash = true,

            view_options = {
                show_hidden = false,
                is_hidden_file = function(name)
                    -- INFO: adapt logic to ignore useless files
                    return name == ".DS_Store" or vim.endswith(name, ".pyc")
                end,
            },

            -- INFO: Keymaps — Only from within Oil
            use_default_keymaps = false,
            keymaps = {
                ["g?"] = actions.show_help,
                ["<CR>"] = actions.select,
                ["<C-t>"] = actions.select_tab,
                ["<C-p>"] = actions.preview,
                ["<C-c>"] = actions.close,
                ["<C-l>"] = actions.refresh,
                ["µ"] = actions.parent,
                ["_"] = actions.open_cwd,
                ["-"] = actions.cd,
                ["gs"] = actions.change_sort,
                ["gx"] = actions.open_external,
                ["g."] = actions.toggle_hidden,
                ["gt"] = actions.toggle_trash,
                ["<C-y>"] = yank_entry_path("@"),
                ["<leader>y"] = yank_entry_path("+"),
            },
        })

        -- INFO: Keymaps
        local map = Mapper({})

        map("n", "µ", "Open parent directory", "<CMD>Oil<CR>")
    end,
}
