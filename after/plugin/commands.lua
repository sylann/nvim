local group = vim.api.nvim_create_augroup("RunnerDump", { clear = true })

--- UI

---@param win integer
---@param buf integer
---@param split "left" | "right" | "above" | "below"
---@return integer
local function create_split_window(win, buf, split)
    win = vim.api.nvim_open_win(buf, false, { win = win, split = split })
    return win
end

---@param buf integer
---@return integer
local function create_floating_window(buf)
    local width = math.min(60, math.floor(vim.o.columns * 0.6))
    local height = math.min(16, math.floor(vim.o.lines * 0.9))
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

--- close windows associated to given buffers (error on unsaved changes)
local function close_windows(buffers)
    local windows = vim.api.nvim_tabpage_list_wins(0)
    local remaining = #windows
    for _, w in ipairs(windows) do
        if remaining == 1 then break end -- Can't close the last window
        local b = vim.api.nvim_win_get_buf(w)
        if vim.tbl_contains(buffers, b) then
            vim.api.nvim_win_close(w, false)
            remaining = remaining - 1
        end
    end
end

--- Buffers

---@param buf integer
---@param lines string[]
local function buf_write_lines(buf, lines)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modified", false)
end

---@param buf integer
---@param text string
local function buf_write_text(buf, text)
    local lines = vim.split(text, "\n", { trimempty = true })
    buf_write_lines(buf, lines)
end

---@param buf integer
---@param filetype string
local function buf_set_filetype(buf, filetype)
    if buf then print("changing filetype to", filetype) end
    if buf then vim.api.nvim_set_option_value("filetype", filetype, { buf = buf }) end
end

---@alias BufferName "config" | "stdout" | "stderr"

---@type table<BufferName, number | nil>
local m_buffers = { config = nil, stdout = nil, stderr = nil }

---@param name BufferName
---@param filetype string
---@return integer
local function buf_create_scratch(name, filetype)
    local buf = m_buffers[name]
    if not buf then
        -- only create the buffer once
        buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_name(buf, "RunnerDump://" .. name)
        vim.api.nvim_set_option_value("filetype", filetype, { buf = buf })
        vim.api.nvim_create_autocmd("BufDelete", {
            group = group,
            buffer = buf,
            once = true,
            callback = function() m_buffers[name] = nil end,
        })
    end
    m_buffers[name] = buf
    return buf -- useful for where this is called, to not have to check for nil
end

local function buf_delete_all()
    for _, buf in pairs(m_buffers) do
        if buf then vim.api.nvim_buf_delete(buf, { force = true }) end
    end
end

--- Autocmds

---@type table<string, integer | nil>
local m_autocmds = {}

local function autocmd_clear(key)
    local existing = m_autocmds[key]
    if existing then
        m_autocmds[key] = nil
        vim.api.nvim_del_autocmd(existing)
    end
end

local function autocmd_clear_all()
    for _, id in pairs(m_autocmds) do
        vim.api.nvim_del_autocmd(id)
    end
end

local function autocmd_on_pattern(event, pattern, callback)
    local key = event .. "__" .. pattern
    autocmd_clear(key)
    m_autocmds[key] = vim.api.nvim_create_autocmd(event, { group = group, pattern = pattern, callback = callback })
end

local function autocmd_on_buffer(event, buffer, callback)
    local key = event .. "__" .. buffer
    autocmd_clear(key)
    vim.api.nvim_create_autocmd(event, { group = group, buffer = buffer, callback = callback })
end

--- Config

---Config variables for RunnerDump
---@class (exact) CfgVariables
---@field pattern string The pattern used by `vim.api.nvim_create_autocmd` — `test.sh`, `*.py`
---@field command string The command used by `vim.system` — `./test.sh`, `python -m mod.script`, `gcc main.c -o a`
---@field timeout_ms string Max execution time for command in milliseconds — `2000`, `200`
---@field subshell string Whether to run `command` in a bash subshell — `true`, ...
---@field out_filetype string Filetype stdout output — `python`, `c`,
---@field err_filetype string Filetype stderr output — `log`, `python`, `text`

---Callbacks to execute on change for some config variables
---@class (exact) CfgBeforeUpdate
---@field pattern? fun(new: string, old: string)>
---@field out_filetype? fun(new: string, old: string)>
---@field err_filetype? fun(new: string, old: string)>

---@type CfgVariables | nil
local m_cfg
---@type CfgBeforeUpdate
local m_cfg_before_update = {}

local m_cfg_var_fmt = "%s = %s"
local m_cfg_var_regex = "^(%w+) *= *(.*)"

--- Command helpers

local function update_config_from_buffer()
    if not m_cfg then return vim.notify("update_config_from_buffer: cfg is not initialized", vim.log.levels.ERROR) end

    local lines = vim.api.nvim_buf_get_lines(m_buffers.config, 0, -1, true)
    local defs = {}
    -- Each line starting with a word followed by an equal sign is a candidate for config updates
    -- but they only take effect if the field actually exists.
    for _, line in ipairs(lines) do
        local key, value = string.match(line, m_cfg_var_regex)
        if key then defs[key] = value end
    end
    for key, oldval in pairs(m_cfg) do
        local newval = defs[key]
        if newval and newval ~= oldval then
            local cb = m_cfg_before_update[key]
            if cb then cb(newval, oldval) end
            m_cfg[key] = newval
            print("cfg changed", key, newval)
        end
    end
end

local function write_command_output()
    if not m_cfg then return vim.notify("write_command_output: cfg is not initialized", vim.log.levels.ERROR) end

    if not m_buffers.stdout and not m_buffers.stderr then return end

    -- TODO: write stdout and stderr from the process instead of from lua?
    local cmd_args = m_cfg.subshell == "true" and { "bash", "-c", m_cfg.command } or vim.split(m_cfg.command, "%s+")
    local timeout = tonumber(m_cfg.timeout_ms, 10)
    local result = vim.system(cmd_args, { text = true, timeout = timeout }):wait()
    if m_buffers.stdout then buf_write_text(m_buffers.stdout, result.stdout) end
    if m_buffers.stderr then buf_write_text(m_buffers.stderr, result.stderr) end
end

local function guess_initial_command()
    local path = vim.fn.expand("%")
    local ext = vim.fn.expand("%:e")
    local ft = vim.o.ft
    if ext == "c" then return "gcc " .. path .. " -o a && { ./a; rm a; }" end
    if ext == "go" then return "go run ." end
    if ext == "py" then return "python " .. path end
    if ext == "sh" or ft == "bash" then return "bash " .. path end
    if ft == "sh" then return "sh " .. path end
    return path
end

--- Plugin commands

-- TODO: add layout options to cfg + store last cfg in shada, by filepath/file_id

local function init_config()
    if m_cfg then return end
    m_cfg = {
        pattern = vim.fn.expand("%:t"), -- NOTE: do this before opening any new buffer
        command = guess_initial_command(), -- NOTE: do this before opening any new buffer
        timeout_ms = "2000",
        subshell = "false",
        out_filetype = "text",
        err_filetype = "text",
    }
    m_cfg_before_update = {
        pattern = function(new) autocmd_on_pattern("BufWritePost", new, write_command_output) end,
        out_filetype = function(new) buf_set_filetype(m_buffers.stdout, new) end,
        err_filetype = function(new) buf_set_filetype(m_buffers.stderr, new) end,
    }
    autocmd_on_pattern("BufWritePost", m_cfg.pattern, write_command_output)
end

local function show_config()
    if not m_cfg then return vim.notify("show_config: cfg is not initialized", vim.log.levels.ERROR) end

    local buf = buf_create_scratch("config", "ini")
    create_floating_window(buf)
    buf_write_lines(m_buffers.config, {
        "# Execute <command>, # On BufWritePost events,",
        "# in files matching <pattern>.",
        "# Set `subshell = true` to run <command> in a",
        "# subshell (with 'bash -c \"<command>\"').",
        "# ====================================================",
        string.format(m_cfg_var_fmt, "pattern", m_cfg.pattern),
        string.format(m_cfg_var_fmt, "command", m_cfg.command),
        string.format(m_cfg_var_fmt, "timeout", m_cfg.timeout_ms),
        string.format(m_cfg_var_fmt, "subshell", m_cfg.subshell),
        string.format(m_cfg_var_fmt, "out_filetype", m_cfg.out_filetype),
        string.format(m_cfg_var_fmt, "err_filetype", m_cfg.err_filetype),
    })
    autocmd_on_buffer("BufHidden", m_buffers.config, update_config_from_buffer)
end

---@param split_stdout "left" | "right" | "above" | "below"
---@param split_stderr "left" | "right" | "above" | "below"
local function show_dump_windows(split_stdout, split_stderr)
    local stdout = buf_create_scratch("stdout", "text")
    local stderr = buf_create_scratch("stderr", "text")
    close_windows({ stdout, stderr }) -- reset layout cleanly
    local win = 0
    win = create_split_window(win, stdout, split_stdout) -- split relative to current window
    win = create_split_window(win, stderr, split_stderr) -- split relative to stdout window
end

-- stylua: ignore start
local function runner_dump_right_below() init_config() show_dump_windows("right", "below") show_config() end
local function runner_dump_above_right() init_config() show_dump_windows("above", "right") show_config() end
local function runner_dump_above_below() init_config() show_dump_windows("above", "below") show_config() end
-- stylua: ignore end

local function runner_clear()
    autocmd_clear_all()
    buf_delete_all()
    m_cfg = nil
    m_cfg_before_update = {}
end

local function runner_restart()
    runner_clear()
    init_config()
    show_config()
end

vim.api.nvim_create_user_command("RunnerDumpRightBelow", runner_dump_right_below, {})
vim.api.nvim_create_user_command("RunnerDumpAboveRight", runner_dump_above_right, {})
vim.api.nvim_create_user_command("RunnerDumpAboveBelow", runner_dump_above_below, {})
vim.api.nvim_create_user_command("RunnerDumpShowCfg", show_config, {})
vim.api.nvim_create_user_command("RunnerDumpClear", runner_clear, {})
vim.api.nvim_create_user_command("RunnerDumpRestart", runner_restart, {})
