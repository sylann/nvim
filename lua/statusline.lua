local _, devicons = pcall(require, "nvim-web-devicons")

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

function UpdateAheadbehind()
    local cmd = { "git", "rev-list", "--left-right", "--count", "HEAD...@{upstream}" }
    local res = vim.system(cmd, { text = true, timeout = 1000 }):wait()
    local a, b
    if res.stdout then
        a, b = res.stdout:match("(%d+)%s(%d+)")
    end
    GitAheadBehind.ahead = a and tonumber(a) or 0
    GitAheadBehind.behind = b and tonumber(b) or 0
end

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, { callback = UpdateAheadbehind })

local function sl_branch()
    local head = vim.b.gitsigns_head
    if not head or head == "" then return "" end
    local a, b = GitAheadBehind.ahead, GitAheadBehind.behind
    local ab = ""
    if a > 0 then ab = ab .. " ↑" .. a end
    if b > 0 then ab = ab .. " ↓" .. b end
    if #head > 25 then head = head:sub(1, 22) .. "…" end
    return "  " .. head .. ab .. " "
end

local function sl_gitsigns()
    local status = vim.b.gitsigns_status_dict
    if not status then return "" end
    local a, c, r = status.added or 0, status.changed or 0, status.removed or 0
    local o = ""
    if a > 0 then o = o .. "%#Added#+" .. a end
    if c > 0 then o = o .. "%#Changed#~" .. c end
    if r > 0 then o = o .. "%#Removed#-" .. r end
    if o ~= "" then o = " " .. o .. "%*" end
    return o
end

local function sl_diagnostics()
    if vim.bo.filetype == "lazy" then return "" end -- Skip diagnostics of LazyNvim

    local buf_diags = vim.diagnostic.get(0)
    local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }
    for _, diag in ipairs(buf_diags) do
        local k = vim.diagnostic.severity[diag.severity]
        counts[k] = counts[k] + 1
    end

    local s = ""
    if counts.ERROR > 0 then s = s .. " %#DiagnosticError# " .. counts.ERROR end
    if counts.WARN > 0 then s = s .. " %#DiagnosticWarn# " .. counts.WARN end
    if counts.INFO > 0 then s = s .. " %#DiagnosticInfo# " .. counts.INFO end
    if counts.HINT > 0 then s = s .. " %#DiagnosticHint# " .. counts.HINT end
    if s == "" then return "" end
    return s:sub(2) .. "%#Statusline# ▏"
end

-- NOTE: The intent is to indicate which filetype is detected. The filename is irrelevant.
local function sl_filetype()
    local ft = vim.bo.filetype
    if not devicons then return ft .. " " end

    local icon, hl = devicons.get_icon_by_filetype(ft)
    if not icon then return ft .. " " end

    return "%#" .. hl .. "#" .. icon .. "%#Sl# " .. ft .. " "
end

local function sl_encoding()
    local encoding = vim.opt.fileencoding:get()
    if encoding == "" then return "" end
    return encoding .. " "
end

local function sl_fileformat()
    local f = vim.bo.fileformat
    if f == "unix" then return "LF " end
    if f == "dos" then return "CRLF " end
    if f == "mac" then return "CR " end
    return f .. "?? "
end

local function sl_filesize()
    local file = vim.fn.expand("%:p")
    if file == nil or #file == 0 then return "  0 " end
    local size = vim.fn.getfsize(file)
    if size <= 0 then return "  0 " end

    local units = { "", "K", "M", "G" }
    local i = 1
    while size > 1024 and i < #units do
        size = size / 1024
        i = i + 1
    end

    local fmt = i == 1 and "  %d%s " or "  %.1f%s "
    return fmt:format(size, units[i])
end

function DrawMyStatusline()
    local mode = get_mode_data()
    vim.cmd("hi link SlPrime " .. mode.hl)
    vim.cmd("hi link SlPrimeText " .. (mode.hl2 or "Statusline"))

    return table.concat(NonBlanks({
        "%#SlPrime# " .. mode.name .. " %*",
        "%#SlAlt#" .. sl_branch() .. "%*",
        sl_gitsigns(),
        " %#SlPrimeText#%{expand('%:~:.')}%( %h%w%q%)%* ",
        "%=%=",
        sl_diagnostics(),
        sl_filetype(),
        sl_encoding(),
        sl_fileformat(),
        "%#SlAlt#",
        sl_filesize(),
        " %L ",
        "%#SlPrime# %p%% %l:%v ",
    }))
end

vim.o.showmode = false
vim.o.statusline = "%!v:lua.DrawMyStatusline()"