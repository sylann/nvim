local M = {}

M.name = "sylfire"

---Use a black background
local dark = 1
---Variation of Dark with some colors being more saturated
local darkest = 2
---Use a white background
local light = 3

M.modes = { dark, darkest, light }
M.mode = dark
M.background = M.mode == light and "light" or "dark"

M.colors = {}

M.colors.ui = {
    bg1            = ({ "#0B0B0B", "#0B0B0B", "#F4F4F4" })[M.mode],
    bg2            = ({ "#121212", "#121212", "#EDEDED" })[M.mode],
    bg3            = ({ "#1B1B1B", "#1B1B1B", "#E4E4E4" })[M.mode],
    bg4            = ({ "#2D2D2D", "#2D2D2D", "#D2D2D2" })[M.mode],
    fg1            = ({ "#D4D4D4", "#D4D4D4", "#000000" })[M.mode],
    fg2            = ({ "#ABB2BF", "#ABB2BF", "#343D30" })[M.mode],
    fg3            = ({ "#8B92A8", "#8B92A8", "#646D67" })[M.mode],
    fg_dim         = ({ "#6B737F", "#6B737F", "#A4ACA0" })[M.mode],
    fg_disabled    = ({ "#545862", "#545862", "#BDBDBD" })[M.mode],
    sel1           = ({ "#083c5a", "#083c5a", "#BEDEFE" })[M.mode],
    sel2           = ({ "#042e48", "#042e48", "#A0D0EE" })[M.mode],
    sel3           = ({ "#022036", "#022036", "#90C1DE" })[M.mode],
    title          = ({ "#519FDF", "#519FDF", "#519FDF" })[M.mode],
    search         = ({ "#3E4451", "#3E4451", "#AFBFEE" })[M.mode],
    match          = ({ "#D8B43C", "#D8B43C", "#D8B43C" })[M.mode],
    match_dim      = ({ "#D5B06B", "#D5B06B", "#D5B06B" })[M.mode],
    cursor         = ({ "#00FF00", "#00FF00", "#00FF00" })[M.mode],
    error          = ({ "#F44747", "#F44747", "#F44747" })[M.mode],
    error_light    = ({ "#F28686", "#F28686", "#F28686" })[M.mode],
    warning        = ({ "#FF8800", "#FF8800", "#FF8800" })[M.mode],
    warning_light  = ({ "#FAAF5E", "#FAAF5E", "#FAAF5E" })[M.mode],
    info           = ({ "#FFCC66", "#FFCC66", "#FFCC66" })[M.mode],
    info_light     = ({ "#F2D996", "#F2D996", "#F2D996" })[M.mode],
    hint           = ({ "#66C9FF", "#66C9FF", "#66C9FF" })[M.mode],
    hint_light     = ({ "#A6D7F2", "#A6D7F2", "#A6D7F2" })[M.mode],
    success        = ({ "#14C50B", "#14C50B", "#14C50B" })[M.mode],
    success_light  = ({ "#AAF2A6", "#AAF2A6", "#AAF2A6" })[M.mode],
    debug          = ({ "#B267E6", "#B267E6", "#B267E6" })[M.mode],
    remove_darkest = ({ "#420000", "#420000", "#420000" })[M.mode],
    remove_dark    = ({ "#720000", "#720000", "#720000" })[M.mode],
    remove         = ({ "#B4151B", "#B4151B", "#B4151B" })[M.mode],
    remove_light   = ({ "#E74E3A", "#E74E3A", "#E74E3A" })[M.mode],
    add_darkest    = ({ "#004200", "#004200", "#004200" })[M.mode],
    add_dark       = ({ "#007200", "#007200", "#007200" })[M.mode],
    add            = ({ "#58BC0C", "#58BC0C", "#58BC0C" })[M.mode],
    add_light      = ({ "#7ED258", "#7ED258", "#7ED258" })[M.mode],
    change_darkest = ({ "#212100", "#212100", "#212100" })[M.mode],
    change_dark    = ({ "#514100", "#514100", "#514100" })[M.mode],
    change         = ({ "#CCA700", "#CCA700", "#CCA700" })[M.mode],
    change_light   = ({ "#EBCB75", "#EBCB75", "#EBCB75" })[M.mode],
}

M.colors.syn = {
    keyword       = ({ "#D14F3E", "#FF3311", "#BB1111" })[M.mode],
    special       = ({ "#7BACB6", "#66BBCC", "#1177BB" })[M.mode],
    procedure     = ({ "#E0873C", "#FF7711", "#775500" })[M.mode],
    macro         = ({ "#9F6DA2", "#9966BB", "#7755CC" })[M.mode],
    type_1        = ({ "#CDAC63", "#F0B030", "#CC9900" })[M.mode],
    type_2        = ({ "#DDB150", "#FFB010", "#CC9900" })[M.mode],
    number        = ({ "#B37986", "#CC6699", "#AA2299" })[M.mode],
    string        = ({ "#CE9178", "#EE9977", "#AA5544" })[M.mode],
    bytes         = ({ "#EDD49D", "#EDD49D", "#AA5544" })[M.mode],
    regex         = ({ "#E79474", "#FF8866", "#AA5544" })[M.mode],
    property      = ({ "#D7C7A4", "#D7C7A4", "#000000" })[M.mode],
    namespace     = ({ "#B2AA93", "#B2AA93", "#000000" })[M.mode],
    symbol        = ({ "#D9D3C1", "#D9D3C1", "#000000" })[M.mode],
    punctuation   = ({ "#757473", "#757473", "#7F6A69" })[M.mode],
    comment       = ({ "#7F775A", "#7F775A", "#7F6A69" })[M.mode],
    docstring     = ({ "#799857", "#799857", "#499847" })[M.mode],
    mark_header_1 = ({ "#B7D407", "#B7D407", "#B7D407" })[M.mode],
    mark_header_2 = ({ "#67BE57", "#67BE57", "#67BE57" })[M.mode],
    mark_header_3 = ({ "#3BC4A6", "#3BC4A6", "#3BC4A6" })[M.mode],
    mark_header_4 = ({ "#4CBCDF", "#4CBCDF", "#4CBCDF" })[M.mode],
    mark_strong   = ({ "#EDD49D", "#EDD49D", "#BB7F3F" })[M.mode],
    mark_emphase  = ({ "#D7C7A4", "#D7C7A4", "#7F775A" })[M.mode],
    mark_raw      = ({ "#CE9178", "#CE9178", "#EE9977" })[M.mode],
    mark_quote    = ({ "#6796E6", "#6796E6", "#6796E6" })[M.mode],
    mark_tag      = ({ "#569CD6", "#569CD6", "#569CD6" })[M.mode],
    mark_tag_bad  = ({ "#A09030", "#A09030", "#A09030" })[M.mode],
}

---@alias Attr "bold" | "italic" | "strikethrough" | "underline" | "undercurl" | "underdouble" | "underdotted" | "underdashed"
---@alias HlHandler fun(name: string, fg: string, bg: string, ...: Attr)
---@alias LinkHandler fun(name: string, target_name: string)

function M.setup()
    ---@type HlHandler
    local hl_handler = function(name, fg, bg, ...)
        local opts = { fg = fg, bg = bg }
        for _, flag in ipairs({ ... }) do
            opts[flag] = true
        end
        vim.api.nvim_set_hl(0, name, opts)
    end

    ---@type LinkHandler
    local link_handler = function(link_name, source_name)
        local opts = { link = source_name }
        vim.api.nvim_set_hl(0, link_name, opts)
    end

    M.configure(hl_handler, link_handler)
end

---Setup highlight groups for this theme
---@param hl HlHandler
---@param link LinkHandler
function M.configure(hl, link)
    vim.o.background = M.background
    vim.o.termguicolors = true
    vim.g.colors_name = M.name

    local _ = "NONE"
    local ui = M.colors.ui
    local syn = M.colors.syn

    -- UI
    hl("ColorColumn", _, ui.bg3)
    hl("Conceal", ui.fg_disabled, _)
    link("CurSearch", "Search")
    hl("Cursor", _, ui.cursor)
    hl("CursorLine", _, ui.bg3)
    hl("CursorLineNr", ui.fg1, ui.bg3)
    hl("Directory", ui.title, _)
    hl("EndOfBuffer", ui.title, _)
    hl("ErrorMsg", ui.error, _, "bold")
    hl("FloatBorder", ui.title, ui.sel3)
    link("FloatFooter", "FloatBorder")
    link("FloatTitle", "FloatBorder")
    hl("FoldColumn", ui.fg_disabled, ui.bg3)
    hl("Folded", ui.fg_disabled, ui.bg3)
    hl("IncSearch", _, ui.fg_dim)
    hl("LineNr", ui.fg_dim, _)
    hl("MatchParen", ui.match, _, "underline")
    hl("MatchParenCur", _, _, "underline")
    hl("ModeMsg", ui.fg1, ui.bg3)
    hl("MoreMsg", ui.title, _)
    hl("MsgArea", ui.fg1, _)
    hl("MsgSeparator", ui.fg1, _)
    hl("NonText", ui.fg_dim, _)
    hl("Normal", ui.fg1, ui.bg1)
    hl("NormalFloat", _, ui.sel3)
    link("NormalNC", "Normal")
    hl("Pmenu", ui.fg1, ui.bg3)
    hl("PmenuSbar", _, ui.bg3)
    hl("PmenuSel", _, ui.sel2)
    hl("PmenuThumb", _, ui.bg3)
    hl("Question", ui.title, _)
    hl("QuickFixLine", _, ui.sel2)
    hl("Search", _, ui.search)
    hl("SignColumn", _, _)
    hl("SpecialKey", ui.title, _, "bold")
    hl("SpellBad", ui.error_light, _, "undercurl")
    hl("SpellCap", ui.info_light, _, "undercurl")
    hl("SpellLocal", ui.warning_light, _, "undercurl")
    hl("SpellRare", ui.debug, _, "undercurl")
    hl("Statusline", ui.fg3, ui.bg3)
    hl("StatusLineNC", ui.fg_disabled, ui.bg1)
    hl("Substitute", ui.fg1, ui.add_dark)
    hl("TabLine", ui.fg_disabled, ui.bg2)
    hl("TabLineFill", _, ui.bg1)
    hl("TabLineSel", ui.fg1, ui.bg3)
    hl("TermCursor", _, ui.fg_dim) -- INFO: this is when terminal mode is active (insert mode in terminal buffer)
    hl("TermCursorNC", _, _)
    hl("Title", ui.title, _, "bold")
    hl("Visual", _, ui.sel2)
    hl("WarningMsg", ui.error, _)
    hl("WildMenu", ui.fg1, _)
    hl("WinSeparator", ui.fg_disabled, _)

    -- Statusline modes (non-standard hl groups)
    hl("SlAlt", ui.fg1, ui.bg4)
    hl("SlNormal", ui.fg1, "#166682")
    hl("SlProtected", ui.bg1, ui.fg1)
    hl("SlModified", ui.fg1, "#CC5533")
    hl("SlModifiedText", "#EE5533", "#2C0A00")
    hl("SlReadonly", ui.bg1, "#8B92A8")
    hl("SlProblem", ui.fg1, "#CC1166")
    hl("SlProblemText", "#CC1166", "#2C000A")
    hl("SlVisual", ui.fg1, "#A130B7")
    hl("SlSelect", ui.fg1, "#A678BD")
    hl("SlInsert", ui.fg1, "#B5800B")
    hl("SlReplace", ui.fg1, "#D5685B")
    hl("SlCommand", ui.fg1, "#199817")
    hl("SlTerminal", ui.fg1, "#199817")

    -- Diagnostics
    hl("DiagnosticError", ui.error, _)
    hl("DiagnosticWarn", ui.warning, _)
    hl("DiagnosticInfo", ui.info, _)
    hl("DiagnosticHint", ui.hint, _)
    hl("DiagnosticOk", ui.success, _)

    -- Git
    hl("diffLine", ui.debug, _)
    hl("diffSubname", ui.fg1, _)
    hl("DiffAdd", _, ui.add_darkest)
    hl("DiffChange", _, ui.change_darkest)
    hl("DiffDelete", _, ui.remove_darkest)
    hl("DiffText", _, ui.change_dark)
    hl("Added", ui.add_light, _)
    hl("Changed", ui.change_light, _)
    hl("Removed", ui.remove_light, _)

    -- Cmp
    hl("SnippetTabstop", _, ui.sel1, "italic")
    hl("SnippyPlaceholder", _, ui.sel2, "italic")
    hl("CmpItemAbbr", ui.fg1, _)
    hl("CmpItemAbbrDeprecated", ui.fg_disabled, _, "strikethrough")
    hl("CmpItemAbbrMatch", ui.info, _, "bold")
    hl("CmpItemAbbrMatchFuzzy", ui.info_light, _)
    hl("CmpItemKindClass", syn.type_2, _)
    hl("CmpItemKindColor", syn.number, _)
    hl("CmpItemKindConstant", syn.number, _)
    hl("CmpItemKindConstructor", syn.special, _)
    hl("CmpItemKindEnum", syn.number, _)
    hl("CmpItemKindEnumMember", syn.number, _)
    hl("CmpItemKindEvent", syn.special, _)
    hl("CmpItemKindField", syn.property, _)
    hl("CmpItemKindFile", syn.symbol, _)
    hl("CmpItemKindFolder", ui.title, _)
    hl("CmpItemKindFunction", syn.procedure, _)
    hl("CmpItemKindInterface", syn.type_1, _)
    hl("CmpItemKindKeyword", syn.keyword, _)
    hl("CmpItemKindMethod", syn.procedure, _)
    hl("CmpItemKindModule", syn.namespace, _)
    hl("CmpItemKindOperator", syn.keyword, _)
    hl("CmpItemKindProperty", syn.property, _)
    hl("CmpItemKindReference", syn.special, _)
    hl("CmpItemKindSnippet", ui.match_dim, _)
    hl("CmpItemKindStruct", syn.type_1, _)
    hl("CmpItemKindText", syn.string, _)
    hl("CmpItemKindTypeParameter", syn.symbol, _)
    hl("CmpItemKindUnit", syn.special, _)
    hl("CmpItemKindValue", syn.number, _)
    hl("CmpItemKindVariable", syn.symbol, _)

    -- LSP
    hl("LspReferenceRead", _, ui.sel2)
    hl("LspReferenceText", _, ui.sel2)
    hl("LspReferenceWrite", _, ui.sel2)
    hl("LspInlayHint", ui.fg3, _)
    hl("LspCodeLens", ui.fg3, _, "italic")
    hl("LspCodeLensSeparator", ui.fg3, _, "italic")
    hl("LspSignatureActiveParameter", ui.info, _)

    -- Telescope
    hl("TelescopeSelection", ui.hint, _)
    hl("TelescopeMatching", _, ui.search, "bold")
    link("TelescopeBorder", "FloatBorder")

    -- Syntax
    hl("Keyword", syn.keyword, _)
    hl("Operator", syn.keyword, _)
    hl("Conditional", syn.keyword, _)
    hl("Repeat", syn.keyword, _)
    hl("Include", syn.keyword, _)
    hl("Exception", syn.keyword, _)
    hl("StorageClass", syn.special, _)
    hl("Structure", syn.type_1, _)
    hl("Typedef", syn.type_1, _)
    hl("Type", syn.type_2, _)
    hl("Variable", syn.symbol, _)
    hl("Identifier", syn.symbol, _)
    hl("Label", syn.property, _)
    hl("String", syn.string, _)
    hl("Character", syn.number, _)
    hl("SpecialChar", syn.number, _)
    hl("Constant", syn.number, _)
    hl("Number", syn.number, _)
    hl("Boolean", syn.number, _)
    hl("Float", syn.number, _)
    hl("Function", syn.procedure, _)
    hl("PreProc", syn.macro, _)
    hl("Define", syn.macro, _)
    hl("Macro", syn.macro, _)
    hl("PreCondit", syn.macro, _)
    hl("Statement", ui.debug, _)
    hl("Special", syn.special, _)
    hl("Tag", syn.mark_tag, _)
    hl("Delimiter", syn.punctuation, _)
    hl("Comment", syn.comment, _, "italic")
    hl("SpecialComment", syn.docstring, _)
    hl("Whitespace", ui.error, _) -- only unwanted whitespaces are shown
    hl("Underlined", _, _, "underline")
    hl("Bold", _, _, "bold")
    hl("Italic", _, _, "italic")
    hl("Ignore", ui.fg_disabled, _, "strikethrough")
    hl("Todo", ui.cursor, _, "bold")
    hl("Error", ui.error, _, "bold")
    hl("Debug", ui.debug, _)

    -- HTML
    hl("htmlTitle", syn.mark_header_1, _, "bold")
    hl("htmlH1", syn.mark_header_1, _, "bold")
    hl("htmlH2", syn.mark_header_2, _, "bold")
    hl("htmlH3", syn.mark_header_3, _, "bold")
    hl("htmlH4", syn.mark_header_4, _, "bold")
    hl("htmlTag", syn.punctuation, _)
    link("htmlEndTag", "htmlTag")
    hl("htmlTagName", syn.mark_tag, _)
    hl("htmlArg", syn.property, _)
    hl("htmlLink", syn.mark_emphase, _, "underline")
    hl("htmlSpecialChar", syn.number, _)

    -- Markdown

    hl("markdownBold", syn.mark_strong, _, "bold")
    hl("markdownBoldDelimiter", syn.punctuation, _, "bold")

    -- vimscript
    hl("vimNotFunc", syn.keyword, _)
    hl("vimFuncKey", syn.keyword, _)
    hl("vimLet", syn.special, _)
    hl("vimFor", syn.keyword, _)
    hl("vimCommand", syn.keyword, _)
    hl("vimEscape", syn.number, _)
    hl("vimFunction", syn.procedure, _)

    -- Syntax (Treesitter)
    hl("@annotation", ui.title, _)
    hl("@attribute", syn.property, _, "bold", "italic")
    hl("@comment.docstring", syn.docstring, _)
    hl("@constant", syn.symbol, _) -- Why did I use symbol here? (2024-08-05)
    hl("@constant.builtin", syn.number, _)
    hl("@emphasis", _, _, "italic")
    hl("@error", ui.error, _)
    link("@function.macro", "Macro")
    hl("@field", syn.property, _)
    hl("@keyword.function", syn.special, _)
    hl("@namespace", syn.namespace, _)
    hl("@parameter.reference", syn.special, _)
    hl("@property", syn.property, _)
    hl("@punctuation.bracket", syn.punctuation, _)
    hl("@punctuation.delimiter", syn.punctuation, _)
    hl("@punctuation.special", syn.punctuation, _)
    hl("@query.linter.error", ui.warning, _)
    hl("@string.regex", syn.regex, _)
    hl("@string.documentation", syn.docstring, _)
    hl("@strong", ui.title, _, "bold")
    hl("@symbol", syn.symbol, _)
    hl("@tag.attribute", syn.property, _)
    hl("@tag.delimiter", syn.punctuation, _)
    hl("@text", syn.string, _)
    hl("@type.builtin", syn.type_2, _, "bold", "italic")
    link("@variable", "Variable")
    hl("@variable.builtin", syn.special, _)
    hl("@constant.git_rebase", syn.type_1, _)
    hl("@spell.markdown", syn.symbol, _)
    hl("@markup.heading.1.markdown", syn.mark_header_1, _, "bold")
    hl("@markup.heading.2.markdown", syn.mark_header_2, _, "bold")
    hl("@markup.heading.3.markdown", syn.mark_header_3, _, "bold")
    hl("@markup.heading.4.markdown", syn.mark_header_4, _, "bold")
    hl("@markup.raw.block.markdown", syn.mark_quote, _, "bold")
    hl("@markup.list.markdown", syn.mark_quote, _)
    hl("@markup.strong.markdown_inline", syn.mark_strong, _, "bold")
    hl("@markup.italic.markdown_inline", syn.mark_emphase, _, "italic")
    hl("@markup.link.url.markdown_inline", syn.mark_raw, _, "underline")
    hl("@markup.link.label.markdown_inline", syn.mark_quote, _, "underline")
    hl("@text.title.1.marker", syn.mark_header_1, _, "bold")
    hl("@text.title.2.marker", syn.mark_header_2, _, "bold")
    hl("@text.title.3.marker", syn.mark_header_3, _, "bold")
    hl("@text.title.4.marker", syn.mark_header_4, _, "bold")
    hl("@text.title.1", syn.mark_header_1, _, "bold")
    hl("@text.title.2", syn.mark_header_2, _, "bold")
    hl("@text.title.3", syn.mark_header_3, _, "bold")
    hl("@text.title.4", syn.mark_header_4, _, "bold")
    hl("@text.bold", syn.mark_strong, _, "bold")
    hl("@text.italic", syn.mark_emphase, _, "italic")

    -- Syntax (LSP)
    hl("@lsp.type.selfKeyword", syn.special, _)
    hl("@lsp.type.selfTypeKeyword", syn.special, _, "bold", "italic")
    hl("@lsp.type.builtinType", syn.type_2, _, "bold", "italic")
    hl("@lsp.type.builtinAttribute", syn.special, _)
    -- hl("@lsp.type.typeParameter", syn.special, _)
    -- hl("@lsp.type.generic", syn.special, _)
    link("@lsp.type.decorator", "@attribute")
    link("@lsp.type.namespace", "@namespace")
    hl("@lsp.type.derive", syn.mark_emphase, _)
    link("@lsp.type.macro", "Macro")
    -- link("@lsp.type.enum", "@namespace")
    hl("@lsp.type.enum", syn.namespace, _, "bold", "italic")
    hl("@lsp.type.enumMember", syn.number, _, "bold", "italic")
    hl("@lsp.type.interface", syn.type_1, _, "italic")
    hl("@lsp.type.typeAlias", syn.type_2, _, "italic")
    hl("@lsp.type.lifetime", syn.special, _, "italic")
    hl("@character.special", syn.special, _)
end

local colorscheme_header = [[hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "%s"

set background=%s

]]

---Generate a vim colorscheme file from the setup theme definitions
---@param filepath string?
function M.generate_colorscheme(filepath)
    local color = require("color")
    filepath = filepath or vim.fn.expand("~") .. "/.config/vim/colors/" .. M.name .. ".vim"

    local f, err = io.open(filepath, "w")
    if not f or err then
        print("Error:", err or "Could not get file handle")
        return
    end

    ---@type HlHandler
    local gen_hi = function(name, fg, bg, ...)
        if name:sub(1, 1) == "@" then return end -- not valid in vim
        local fmt = "hi %s guifg=%s guibg=%s gui=%s ctermfg=%s ctermbg=%s cterm=%s\n"
        local flags = { ... }
        local attrs = #flags > 0 and table.concat(flags, ",") or "NONE"
        local tfg = color.hex_to_xterm(fg) or "NONE"
        local tbg = color.hex_to_xterm(bg) or "NONE"
        f:write(fmt:format(name, fg, bg, attrs, tfg, tbg, attrs))
    end

    ---@type LinkHandler
    local function gen_link(name, target_name)
        if name:sub(1, 1) == "@" then return end -- not valid in vim
        local fmt = "hi link %s %s\n"
        f:write(fmt:format(name, target_name))
    end

    f:write(colorscheme_header:format(M.name, M.background))
    M.configure(gen_hi, gen_link)
    f:flush()
    f:close()
end

return M
