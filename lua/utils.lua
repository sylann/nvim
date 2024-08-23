-- INFO: Bridge new lua features that are helpful and easy to emulate.
-- Compatibility Aug 2024:
--   Latest lua version: 5.4
--   Neovim lua version: 5.1 (latest supported by LuaJit)
table.unpack = table.unpack or unpack

---Create a copy of the given `source` table.
---@generic T : table<string, any>
---@param source T
---@return T
table.copy = function(source)
    local out = {}
    for k, v in pairs(source) do
          out[k] = v
    end
    return out
end

--- Create a map function with pre-baked options.
--- It takes a table of base options appropriate for use by `vim.keymap.set`
--- and returns a new function that can be used like `vim.keymap.set` except
--- the signature is (mode, keys, desc, command).
--- The resulting call to vim.keymap.set will be:
---
--- vim.keymap.set(mode, keys, command, { desc = desc, ...baseopts })
---
--- This helper is only meant to make it easier to declare consecutive keymaps
--- with common base options, and assuming a description is always wanted.
---
--- @param baseopts table
--- @return function
function Mapper(baseopts)
    return function(mode, keys, desc, command)
        local opts = { desc = desc }
        for k, v in pairs(baseopts) do
            opts[k] = v
        end
        vim.keymap.set(mode, keys, command, opts)
    end
end

---Create a new array where all blank strings are removed.
---A string is considered blank if it empty or only contains whitespaces.
---@param items string[]
---@return string[]
function NonBlanks(items)
    local parts = {}
    for _, item in ipairs(items) do
        if item:find("%S") then table.insert(parts, item) end
    end
    return parts
end
