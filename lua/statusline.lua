local _, devicons = pcall(require, "nvim-web-devicons")

---@class SlOptions
---@field hl? string name of a highlight group
---@field pl? string left padding
---@field pr? string right padding

---@class SlItem : SlOptions
---@field text string actual content of the item

local cached = {}
---Create a new highlight group by reusing the foreground color of the
---existing group highlight fgname and the background color of bgname.
---The name of the new highlight group is <fgname>And<bgname>.
---@param fgname string
---@param bgname string
---@return string
local function combine_hl(fgname, bgname)
    local name = fgname .. "And" .. bgname
    if not cached[name] then
        local fg = vim.api.nvim_get_hl(0, { name = fgname })
        local bg = vim.api.nvim_get_hl(0, { name = bgname })
        vim.api.nvim_set_hl(0, name, { fg = fg.fg, bg = bg.bg })
        cached[name] = true
    end
    return name
end

---Set hl on items that don't already have one and
---set pl of first item and pr of last item.
---@param opt SlOptions
---@param content string | SlItem | SlItem[]
---@return SlItem[]
local function sl_block(opt, content)
    local items ---@type SlItem[]
    if type(content) == "string" then
        items = { { text = content } }
    elseif content.text then
        items = { content }
    else
        items = content
    end
    if #items > 0 then
        items[1].pl = opt.pl
        items[#items].pr = opt.pr
    end
    if opt.hl then
        for _, item in ipairs(items) do
            if not item.hl then
                item.hl = opt.hl
            elseif item.hl ~= opt.hl then
                item.hl = combine_hl(item.hl, opt.hl) -- use item fg color and block bg color
            end
        end
    end
    return items
end

---@param blocks SlItem[][]
---@return string
local function sl_render_blocks(blocks)
    local hl = nil
    local chunks = {}
    for _, items in ipairs(blocks) do
        for _, item in ipairs(items) do
            if item.text and item.text ~= "" then
                if item.hl then
                    if not hl then
                        hl = item.hl
                        table.insert(chunks, "%#" .. hl .. "#") -- start hl
                    elseif hl ~= item.hl then
                        hl = item.hl
                        table.insert(chunks, "%*") -- end previous hl
                        table.insert(chunks, "%#" .. hl .. "#") -- start hl
                    else
                        -- otherwise continue with current hl
                    end
                end

                if item.pl then table.insert(chunks, item.pl) end
                table.insert(chunks, item.text)
                if item.pr then table.insert(chunks, item.pr) end
            end
        end
    end
    if hl then
        table.insert(chunks, "%*") -- end previous hl
    end
    return table.concat(chunks)
end

-- stylua: ignore
local modes = {
    NORMAL      = { hl = "SlNormal",    name = "NORMAL"                                    },
    MODIFIED    = { hl = "SlModified",  name = "MODIFIED", hl2 = "SlModifiedText"          },
    READONLY    = { hl = "SlReadonly",  name = "READONLY"                                  },
    PROTECTED   = { hl = "SlProtected", name = "PROTECTED"                                 },
    READONLYMOD = { hl = "SlProblem",   name = "READONLY (changed)", hl2 = "SlProblemText" },
    VISUAL      = { hl = "SlVisual",    name = "VISUAL"                                    },
    VISUALLI    = { hl = "SlVisual",    name = "VISUAL LINE"                               },
    VISUALBL    = { hl = "SlVisual",    name = "VISUAL BLOCK"                              },
    SELECT      = { hl = "SlSelect",    name = "SELECT"                                    },
    SELECTLI    = { hl = "SlSelect",    name = "SELECT LINE"                               },
    SELECTBL    = { hl = "SlSelect",    name = "SELECT BLOCK"                              },
    INSERT      = { hl = "SlInsert",    name = "INSERT"                                    },
    INSERTPA    = { hl = "SlInsert",    name = "INSERT (paste)"                            },
    REPLACE     = { hl = "SlReplace",   name = "REPLACE"                                   },
    REPLACEPA   = { hl = "SlReplace",   name = "REPLACE (paste)"                           },
    COMMAND     = { hl = "SlCommand",   name = "COMMAND"                                   },
    TERMINAL    = { hl = "SlTerminal",  name = "TERMINAL"                                  },
    UNKNOWN     = { hl = "SlProblem",   name = "UNKNOWN", hl2 = "SlProblemText"            },
}

local function get_mode_data()
    local m = vim.fn.mode()
    local ro = vim.bo.readonly
    local ch = vim.bo.modified
    local pr = not vim.bo.modifiable
    local pa = vim.go.paste
    if m == "n" and pr then return modes.PROTECTED end
    if m == "n" and ro and ch then return modes.READONLYMOD end
    if m == "n" and ch then return modes.MODIFIED end
    if m == "n" and ro then return modes.READONLY end
    if m == "n" then return modes.NORMAL end
    if m == "v" then return modes.VISUAL end
    if m == "V" then return modes.VISUALLI end
    if m == "" then return modes.VISUALBL end
    if m == "s" then return modes.SELECT end
    if m == "S" then return modes.SELECTLI end
    if m == "" then return modes.SELECTBL end
    if m == "i" and pa then return modes.INSERTPA end
    if m == "i" then return modes.INSERT end
    if m == "R" and pa then return modes.REPLACEPA end
    if m == "R" then return modes.REPLACE end
    if m == "c" or m == "r" then return modes.COMMAND end
    if m == "t" or m == "!" then return modes.TERMINAL end
    return modes.UNKNOWN -- Should not arrive here: fix it if it happens
end

GitAheadBehind = { ahead = 0, behind = 0 }

function UpdateAheadBehind()
    local cmd = vim.split("git rev-list --left-right --count HEAD...@{upstream}", " ")
    local cwd = vim.fn.expand("%:h")
    if cwd == "" or cwd:match("^%w+:") then return end -- skip buffers that are not real files

    local res = vim.system(cmd, { text = true, timeout = 1000, cwd = cwd }):wait()
    local a, b
    if res.stdout then
        a, b = res.stdout:match("(%d+)%s(%d+)")
    end
    GitAheadBehind.ahead = a and tonumber(a) or 0
    GitAheadBehind.behind = b and tonumber(b) or 0
end

vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter" }, { callback = UpdateAheadBehind })
vim.api.nvim_create_autocmd({ "User" }, {
    pattern = { "FugitiveChanged" },
    callback = UpdateAheadBehind,
})

local function sl_branch()
    local items = {} ---@type SlItem[]
    local head, a, b = vim.b.gitsigns_head, GitAheadBehind.ahead, GitAheadBehind.behind
    if head and head ~= "" then
        if #head > 25 then head = head:sub(1, 22) .. "…" end
        table.insert(items, { text = "" })
        table.insert(items, { text = head, pl = " " })
        if a > 0 then table.insert(items, { text = "↑" .. a, pl = " " }) end
        if b > 0 then table.insert(items, { text = "↓" .. b, pl = " " }) end
    end
    return items
end

local diagHls = { "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint" }
local diagIcons = { "", "", "", "" }

local function sl_diagnostics()
    local items = {} ---@type SlItem[]
    for severity, count in pairs(vim.diagnostic.count()) do
        local hl, icon = diagHls[severity], diagIcons[severity]
        table.insert(items, { hl = hl, text = icon, pl = " " })
        table.insert(items, { hl = hl, text = count, pl = " " })
    end
    return items
end

local function sl_filetype()
    local items = {} ---@type SlItem[]
    local ft = vim.bo.filetype
    if devicons then
        local icon, iconhl = devicons.get_icon_by_filetype(ft)
        if icon then table.insert(items, { text = icon, hl = iconhl, pr = " " }) end
    end
    table.insert(items, { text = ft })
    return items
end

---@return string
local function sl_fileformat()
    local f = vim.bo.fileformat
    if f == "unix" then return "LF" end
    if f == "dos" then return "CRLF" end
    if f == "mac" then return "CR" end
    return f .. "??"
end

---@return string
local function format_size(size)
    local units = { "", "K", "M", "G" }
    local i = 1
    while size > 1024 and i < #units do
        size = size / 1024
        i = i + 1
    end
    local fmt = i == 1 and "%d%s" or "%.1f%s"
    return fmt:format(size, units[i])
end

---@return string
local function sl_filesize()
    local file = vim.fn.expand("%:p")
    local size = file and #file > 0 and vim.fn.getfsize(file) or 0
    return " " .. format_size(size)
end

function DrawMyStatusline()
    local mode = get_mode_data()
    local hl_ = "Statusline"
    local alt = "SlAlt"
    local hl1 = mode.hl
    local hl2 = mode.hl2
    return sl_render_blocks({
        sl_block({ pl = " ", pr = " ", hl = hl1 }, mode.name),
        sl_block({ pl = " ", pr = " ", hl = hl2 or hl_ }, "%{expand('%:~:.')}%( %h%w%q%)"),
        sl_block({ pl = " ", pr = " ", hl = alt }, sl_diagnostics()),
        sl_block({ pl = nil, pr = nil, hl = hl_ }, "%="),
        sl_block({ pl = " ", pr = " ", hl = hl_ }, vim.opt.fileencoding:get()),
        sl_block({ pl = nil, pr = " ", hl = hl_ }, sl_fileformat()),
        sl_block({ pl = nil, pr = " ", hl = hl_ }, sl_filetype()),
        sl_block({ pl = " ", pr = " ", hl = alt }, sl_filesize()),
        sl_block({ pl = nil, pr = " ", hl = alt }, " %l/%L :%v"),
        sl_block({ pl = " ", pr = " ", hl = hl1 }, sl_branch()),
    })
end

vim.o.statusline = "%!v:lua.DrawMyStatusline()"
