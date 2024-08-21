local M = {}

local function load_tsv_table(filename, t, expected_headers)
    local iter_line = io.lines(vim.fn.stdpath("config") .. "/assets/" .. filename)
    local header_line = iter_line()
    if not header_line then return end

    local SEP = "	"
    local headers = vim.fn.split(header_line, SEP)
    vim.fn.assert_equal(headers, expected_headers)

    for line in iter_line do
        local data = vim.fn.split(line, SEP)
        local key = data[1] -- first column as lookup key by default
        if key then
            t[key] = {}
            for i, colname in ipairs(headers) do
                t[key][colname] = data[i]
            end
        end
    end
end

---@class (exact) IconEntry
---@field name string
---@field icon string
---@field color string

---This table will not be exhaustive on purpose. It will only contain special cases
---where the filetype is not already a key in either of the icon tables below.
---@type table<string, string>
local special_name_by_filetype = {}

---@type table<string, IconEntry>
local icons_by_filename = {}

---@type table<string, IconEntry>
local icons_by_file_extension = {}

local loaded = false

---Try and get icon data appropriate for the given filetype.
---@param filetype string
---@return IconEntry
function M.get_icon_by_filetype(filetype)
    if not loaded then
        load_tsv_table("name-by-filetype.tsv", special_name_by_filetype, { "filetype", "name" })
        load_tsv_table("icon-by-filename.tsv", icons_by_filename, { "ext", "icon", "color", "name" })
        load_tsv_table("icon-by-extension.tsv", icons_by_file_extension, { "filename", "icon", "color", "name" })
        loaded = true
    end

    local name = special_name_by_filetype[filetype] or filetype
    local icon = icons_by_filename[name]
    return icon or icons_by_file_extension[name]
end

M.icon_by_symbol_kind = {
    Class = " ",
    Color = " ",
    Constant = " ",
    Constructor = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = " ",
    Interface = " ",
    Keyword = " ",
    Method = " ",
    Module = " ",
    Operator = " ",
    Property = " ",
    Reference = " ",
    Snippet = " ",
    Struct = " ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = " ",
}

return M
