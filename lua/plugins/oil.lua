local root_dirs = { vim.fn.getcwd() }
local root_dir_menu_bufnr = nil

local function rdm_select_entry()
    local dir = vim.api.nvim_get_current_line()
    vim.cmd({ cmd = "cd", args = { dir } })
    vim.api.nvim_win_close(0, true)
    vim.notify(string.format("CWD: %s", dir), vim.log.levels.INFO)
end

local function rdm_delete_entry()
    if #root_dirs == 1 then return end
    local row_index = vim.api.nvim_win_get_cursor(0)[1]
    table.remove(root_dirs, row_index)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, root_dirs)
end

local function rdm_close() vim.api.nvim_win_close(0, true) end

-- TODO: extract an util function for this recurring need (create_floating_window), need to figure out good defaults

---@param buf integer
---@return integer
local function create_floating_window(buf)
    local width = math.min(80, math.floor(vim.o.columns * 0.8))
    local height = math.min(#root_dirs, math.floor(vim.o.lines * 0.8))
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "win",
        border = "rounded",
        width = width,
        height = height,
        row = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
    })
    vim.api.nvim_set_option_value("number", false, { win = win })
    vim.api.nvim_set_option_value("relativenumber", false, { win = win })
    return win
end

local function rdm_open()
    local buf = root_dir_menu_bufnr
    if not buf then
        buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_name(buf, "oil://root-dir-history")
        root_dir_menu_bufnr = buf
    end

    create_floating_window(buf)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, root_dirs)
    vim.api.nvim_set_option_value("modified", false, { buf = buf })

    vim.api.nvim_buf_set_keymap(buf, "n", "d", "", { callback = rdm_delete_entry })
    vim.api.nvim_buf_set_keymap(buf, "n", "q", "", { callback = rdm_close })
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "", { callback = rdm_close })
    vim.api.nvim_buf_set_keymap(buf, "n", "<Enter>", "", { callback = rdm_select_entry })
end

local function cd_with_history()
    local dir = require("oil").get_current_dir()
    if dir then
        vim.cmd({ cmd = "cd", args = { dir } })
        if not vim.tbl_contains(root_dirs, dir) then table.insert(root_dirs, dir) end
        vim.notify(string.format("CWD: %s", dir), vim.log.levels.INFO)
    else
        vim.notify("Cannot :cd; not in a directory", vim.log.levels.WARN)
    end
end

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
                ["="] = actions.open_cwd,
                ["-"] = cd_with_history,
                ["_"] = rdm_open,
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
