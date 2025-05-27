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

---The given value is a table and does not look like an array (v[1] is nil)
---@param v unknown
---@return boolean
table.isdict = function(v)
    return type(v) == "table" and v[1] == nil
end

---The given value is a table and looks like an array (v[1] is not nil)
---@param v unknown
---@return boolean
table.isarray = function(v)
    return type(v) == "table" and v[1] ~= nil
end

---Merge given tables into a single new one.
---Already existing keys are overriden by default.
---Tables are merged reccursively but only if they don't look like arrays (no 1-index).
---@param ... table
---@return table
table.merge = function(...)
    local out = {}
    for _, t in ipairs({ ... }) do
        for k, v in pairs(t) do
            if table.isdict(v) and table.isdict(out[k]) then
                out[k] = table.merge(out[k], v)
            else
                out[k] = v
            end
        end
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

---This correponds to the 'opts' argument in `vim.keymap.set(mode, lhs, rhs, opts)`.
---@class KeymapSetOptions
---@field desc string
---@field buffer integer|boolean  Creates buffer-local mapping. `0` or `true` for current buffer.
---@field remap boolean           Default: `false`. Make the mapping recursive. Inverse of {noremap}.
---@field expr boolean            Default: `false`.
---@field unique boolean          Default: `false`.
---@field nowait boolean          Default: `false`.
---@field silent boolean          Default: `false`.
---@field script boolean          Default: `false`.

---Shortcut function that takes parameters in a way that make keymap declarations more compact and readable.
---
--- The following:
---     local map = Mapper({ buffer = 0 })
---     map("n", "ghi", "Prints 'hi'", ":echo hi<CR>")
---     map("n", "gby", "Prints 'bye'", ":echo bye<CR>")
---
--- Is equivalent to:
---     vim.keymap.set("n", "ghi", ":echo hi<CR>", { desc = "Prints 'hi'", buffer = 0 })
---     vim.keymap.set("n", "gby", ":echo bye<CR>", { desc = "Prints 'bye'", buffer = 0 })
---
---@alias MapShortcutFunction fun(mode: string|string[], keys: string|string[], desc: string, command: string|function)

--- Create a shortcut function for `vim.keymap.set` that is primarily less verbose
--- when adding descriptions, but also allows predefining some options such as buffer, etc...
--- Useful when defining several related keymaps.
--- @param baseopts KeymapSetOptions
--- @return MapShortcutFunction
function Mapper(baseopts)
    return function(mode, keys, desc, command)
        local opts = table.merge({ desc = desc }, baseopts)
        vim.keymap.set(mode, keys, command, opts)
    end
end

---Create a new function that calls the given f with the given options.
---If multiple option tables are given, they are merged in a single table.
---@param f function
---@param ... table
---@return function
function Custom(f, ...)
    local fo = table.merge(...)
    return function() f(fo) end
end

local static_paths = {
    ["@state"] = vim.fn.expand("~") .. "/.local/state/nvim",
    ["@lazy"] = vim.fn.expand("~") .. "/.local/share/nvim/lazy",
    ["@data"] = vim.fn.expand("~") .. "/.local/share/nvim",
    ["@cache"] = vim.fn.expand("~") .. "/.cache/nvim",
    ["@config"] = vim.fn.expand("~") .. "/.config/nvim",
    ["@runlua"] = "/usr/share/nvim/runtime/lua",
}
local cached_clean = {}
function CleanFilename(filename)
    local cached = cached_clean[filename]
    print(string.format("CleanFilename: %s => %s", filename, cached))
    if cached then return cached end
    local cwd = vim.fn.getcwd() .. "/"
    local cleaned = string.gsub(filename, cwd, "", 1)
    if cleaned ~= filename then goto done end

    for name, path in pairs(static_paths) do
        cleaned = string.gsub(filename, path, name, 1)
        if cleaned ~= filename then goto done end
    end

    ::done::
    cached_clean[filename] = cleaned
    return cleaned
end
