local enabled = false

---@param value boolean
local function set_virtual_lines(value)
    enabled = value
    vim.diagnostic.config({ virtual_lines = enabled })
end

local function toggle_virtual_lines()
    set_virtual_lines(not enabled)
end

set_virtual_lines(false)

local map = Mapper({})

map("n", "<leader>k", "Toggles virtual lines displaying LSP diagnostics", toggle_virtual_lines)
