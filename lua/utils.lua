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

---Remove elements from `tabl` if they verify the `must_be_removed` predicate.
---The table is modified in place.
---@generic T
---@param tabl table<integer, T>
---@param must_be_removed fun(element: T): boolean
---@return integer n_removed
table.splice = function(tabl, must_be_removed)
    local removed = 0
    for idx = 1, #tabl do
        if must_be_removed(tabl[idx]) then
            removed = removed + 1
        else
            tabl[idx - removed] = tabl[idx]
        end
    end
    for i = #tabl - removed + 1, #tabl do
        tabl[i] = nil
    end
    return removed
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
