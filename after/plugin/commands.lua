local group = vim.api.nvim_create_augroup("MakeRunnerDump", { clear = true })
local cmd_event = "BufWritePost"
local prefix_pattern = "Pattern: "
local prefix_command = "Execute: "

---@param bufnr number
---@param pattern string
---@param command string
local function write_header(bufnr, pattern, command)
    local lines = {
        string.format("On %s events in files matching <Pattern>, execute <Command>", cmd_event),
    }
    local i_vars = #lines -- 0-based index of next item, for use in nvim_buf_set_lines
    table.insert(lines, prefix_pattern .. pattern)
    table.insert(lines, prefix_command .. command)
    table.insert(lines, "====================")
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
    vim.api.nvim_buf_set_option(bufnr, "modified", false)
    return i_vars, #lines
end

local last_bufnr = nil

---@param bufnr number
local function restore_runner_dump(bufnr)
    local in_a_window = vim.fn.bufwinid(bufnr) ~= -1
    if not in_a_window then
        vim.cmd.vertical()
        vim.cmd.sbuffer(bufnr)
    end
end

local make_runner_dump = function()
    if last_bufnr then return restore_runner_dump(last_bufnr) end

    local buf_visible = true
    local cur_pattern = vim.fn.expand("%:t") -- NOTE: must do this before opening new buffer
    local cur_command = vim.fn.expand("%:p")

    vim.cmd.vnew()
    local dump_bufnr = vim.api.nvim_get_current_buf()
    last_bufnr = dump_bufnr

    local i_vars, i_dump = write_header(dump_bufnr, cur_pattern, cur_command)

    ---@type table<fun(ev: any), number>
    local handles = {}

    ---@param cb fun(ev: any): string
    local function unlisten_event(cb)
        local existing = handles[cb]
        if existing then vim.api.nvim_del_autocmd(existing) end
    end

    ---@param event string
    ---@param bufnr_or_pattern string|number
    ---@param cb fun(ev: any)
    local function listen_event(event, bufnr_or_pattern, cb)
        local t = type(bufnr_or_pattern)
        local key = ({ number = "buffer", string = "pattern" })[t]
        assert(key, "bufnr_or_pattern must be number or string. Got " .. t)
        unlisten_event(cb)
        handles[cb] = vim.api.nvim_create_autocmd(event, { group = group, [key] = bufnr_or_pattern, callback = cb })
        -- print(string.format("LISTEN[%d]  %s  %s", handles[cb], event, bufnr or pattern))
    end

    local function clear_event_listeners()
        for _, autocmd_id in pairs(handles) do
            vim.api.nvim_del_autocmd(autocmd_id)
        end
    end

    local function run_cmd_if_dump_visible()
        -- print(string.format("@%s buf=%d visible=%s", cmd_event, dump_bufnr, buf_visible))
        if not buf_visible then return end

        vim.api.nvim_buf_set_lines(dump_bufnr, i_dump, -1, true, {})

        local function make_write_dump(title)
            return function(_, data)
                assert(data, "data shouldn't be nil")
                assert(#data > 0, "data should have at least 1 line")
                vim.api.nvim_buf_set_lines(dump_bufnr, -1, -1, false, { title })
                vim.api.nvim_buf_set_lines(dump_bufnr, -1, -1, false, data)
                vim.api.nvim_buf_set_option(dump_bufnr, "modified", false)
            end
        end

        -- print("  jobstart: " .. cur_command)
        vim.fn.jobstart(cur_command, {
            stdout_buffered = true, -- collect buffered stdout in one single event
            stderr_buffered = true, -- collect buffered stderr in one single event
            on_stdout = make_write_dump("STDOUT:"),
            on_stderr = make_write_dump("STDERR:"),
        })
    end

    ---@param pattern string
    local function set_on_cmd_event(pattern)
        if pattern ~= "" then
            listen_event(cmd_event, pattern, run_cmd_if_dump_visible)
        else
            unlisten_event(run_cmd_if_dump_visible)
        end
    end
    set_on_cmd_event(cur_pattern)

    ---@param value string
    local function update_pattern(value)
        if cur_pattern == value then return end
        print("cur_pattern =", value)
        cur_pattern = value
        set_on_cmd_event(cur_pattern)
    end

    ---@param value string
    local function update_command(value)
        if cur_command == value then return end
        -- print("cur_command =", value)
        cur_command = value
    end

    listen_event("BufLeave", dump_bufnr, function()
        local var_lines = vim.api.nvim_buf_get_lines(dump_bufnr, i_vars, i_vars + 2, true)
        assert(#var_lines == 2, "unexpected number of input lines")
        update_pattern(string.sub(var_lines[1], #prefix_pattern + 1))
        update_command(string.sub(var_lines[2], #prefix_command + 1))
        vim.api.nvim_buf_set_option(dump_bufnr, "modified", false)
    end)
    listen_event("BufHidden", dump_bufnr, function() buf_visible = false end)
    listen_event("BufWinEnter", dump_bufnr, function() buf_visible = true end)

    vim.api.nvim_create_autocmd("BufDelete", {
        group = group,
        buffer = dump_bufnr,
        once = true,
        callback = clear_event_listeners,
    })
end

local description = "Initialize a buffer in a vertical split to dump the output of a command"

vim.api.nvim_create_user_command("MakeRunnerDump", make_runner_dump, { desc = description })
vim.keymap.set("n", "<C-w>w", make_runner_dump, { desc = description })
