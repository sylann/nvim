local memo = { "horizontal", "+", vim.fn.reltime() }

---@param split "vertical" | "horizontal"
---@param sign "-" | "+"
local function pane_resizer(split, sign)
    local resize_step = 1
    return function()
        -- Impossible to resize a single window
        local windows = vim.api.nvim_tabpage_list_wins(0)
        if #windows == 1 then return end

        local timestamp = vim.fn.reltime()
        local old_split, old_sign, old_timestamp = memo[1], memo[2], memo[3]

        -- See if current window has nothing to its right or below
        local win = vim.api.nvim_get_current_win()
        local nothing_further = false
        if split == "vertical" then
            local screen_width = vim.api.nvim_get_option_value("columns", {})
            local left = vim.api.nvim_win_get_position(win)[2] -- { top, left }
            local win_width = vim.api.nvim_win_get_width(win)
            local right = left + win_width
            nothing_further = right == screen_width
            if nothing_further and left == 0 then return end -- nothing both left and right
        else
            local screen_height = vim.api.nvim_get_option_value("lines", {})
            local top = vim.api.nvim_win_get_position(win)[1] -- { top, left }
            local win_height = vim.api.nvim_win_get_height(win)
            local bottom = top + win_height
            nothing_further = bottom == (screen_height - 2) -- account for status line and message line
            if nothing_further and top == 0 then return end -- nothing both above and below
        end

        -- Adjust speed according to split, sign and timestamp
        local delta_t = vim.fn.reltimefloat(vim.fn.reltime(old_timestamp, timestamp))
        if split ~= old_split or sign ~= old_sign or delta_t > 0.25 then
            resize_step = 1 -- reset
        elseif delta_t > 0.15 then
            resize_step = 2 -- go faster
        else
            resize_step = 4 -- fo full speed
        end

        memo[1], memo[2], memo[3] = split, sign, timestamp

        -- Finalize the command and don't mutate split and sign!
        local modifier = split == "vertical" and "vertical" or ""
        local swap = { ["+"] = "-", ["-"] = "+" }
        local actual_sign = nothing_further and swap[sign] or sign
        local cmd = string.format(":silent %s resize %s%d<CR>", modifier, actual_sign, resize_step)

        vim.cmd(cmd)
    end
end

vim.keymap.set("n", "<S-Left>", pane_resizer("vertical", "-"), { desc = "Decrease width of vertical split pane" })
vim.keymap.set("n", "<S-Right>", pane_resizer("vertical", "+"), { desc = "Increase width of vertical split pane" })
vim.keymap.set("n", "<S-Up>", pane_resizer("horizontal", "-"), { desc = "Decrease height of horizontal split pane" })
vim.keymap.set("n", "<S-Down>", pane_resizer("horizontal", "+"), { desc = "Increase height of horizontal split pane" })
