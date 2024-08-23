local M = {}

M.name = "sylfire"
M.background = "dark"
M.colors = {}

M.colors.ui = {
    black = "#000000",
    white = "#FFFFFF",
    gray_950 = "#0B0B0B",
    gray_900 = "#191919",
    gray_800 = "#1B1F27",
    gray_700 = "#282c34",
    gray_600 = "#3E4451",
    gray_500 = "#545862",
    gray_400 = "#6B737F",
    gray_300 = "#8B92A8",
    gray_200 = "#ABB2BF",
    gray_100 = "#C8CCD4",
    gray_050 = "#D4D4D4",
    blue_900 = "#042e48",
    blue_800 = "#083c5a",
    blue_700 = "#264f78",
    blue_600 = "#007ACC",
    blue_500 = "#0195f7",
    blue_folder = "#519FDF",
    blue_note = "#77A0EE",
    brown = "#613214",
    copper = "#C18A56",
    orange_soft = "#E79E61",
    orange_intense = "#FF7733",
    yellow_canari = "#FFCB6B",
    yellow_light = "#D5B06B",
    yellow_mid = "#D8B43C",
    yellow_alt = "#EFBA42",
    yellow_sunset = "#E8AB53",
    yellow_gold = "#F3B735",
    green_dark = "#118811",
    green_mid = "#88B369",
    green_lime = "#69D847",
    green_pure = "#00FF00",
    coffee = "#C0FFEE",
    cyan_dark = "#46A6B2",
    violet = "#B180D7",
    magenta = "#B668CD",
    pink_dark = "#D16D9E",
    pink_intense = "#CC1166",
    red_400 = "#f07178",
    red_500 = "#F05060",
}

M.colors.util = {
    error = "#F44747",
    error_100 = "#F28686",
    warning = "#FF8800",
    warning_100 = "#FAAF5E",
    info = "#FFCC66",
    info_100 = "#F2D996",
    hint = "#66C9FF",
    hint_100 = "#A6D7F2",
    success = "#14C50B",
    success_100 = "#AAF2A6",
    debug = "#B267E6",
    remove_950 = "#420000",
    remove_600 = "#B4151B",
    remove_300 = "#E74E3A",
    add_950 = "#004200",
    add_600 = "#58BC0C",
    add_300 = "#7ED258",
    change_950 = "#212100",
    change_600 = "#CCA700",
    change_300 = "#EBCB75",
}

M.colors.syn = {
    keyword = "#D14F3E",
    special = "#7BACB6",
    procedure = "#E0873C",
    macro = "#9F6DA2",
    type_1 = "#CDAC63",
    type_2 = "#DDB150",
    number = "#B37986",
    string = "#CE9178",
    bytes = "#EDD49D",
    regex = "#E79474",
    property = "#D7C7A4",
    namespace = "#B2AA93",
    symbol = "#D9D3C1",
    punctuation = "#757473",
    comment = "#6F655A",
    docstring = "#799857",
    mark_header_1 = "#D7F447",
    mark_header_2 = "#77CE57",
    mark_header_3 = "#3BC4A6",
    mark_header_4 = "#4CBCDF",
    mark_strong = "#8FB2EF",
    mark_emphase = "#ACC6F2",
    mark_raw = "#CE9178",
    mark_quote = "#6796E6",
    mark_tag = "#569CD6",
    mark_tag_bad = "#A09030",
}

---@alias HlHandler fun(name: string, fg: string, bg: string, ...: string)
---@alias LinkHandler fun(name: string, target_name: string)

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

---Setup highlight groups for this theme
---@param hl_delegate HlHandler?
---@param link_delegate LinkHandler?
function M.setup(hl_delegate, link_delegate)
    vim.o.background = M.background
    vim.o.termguicolors = true
    vim.g.colors_name = M.name

    local _ = "NONE"
    local U = "underline"
    local B = "bold"
    local I = "italic"
    local S = "strikethrough"

    local hl = hl_delegate or hl_handler
    local link = link_delegate or link_handler

    local ui = M.colors.ui
    local syn = M.colors.syn
    local util = M.colors.util

    -- UI
    hl("ColorColumn", _, ui.gray_800)
    hl("Conceal", ui.gray_500, _)
    hl("Cursor", ui.green_pure, ui.green_dark)
    hl("CursorColumn", _, ui.gray_900)
    hl("CursorIM", ui.green_pure, ui.green_dark)
    hl("CursorLine", _, ui.gray_900)
    hl("CursorLineNr", ui.gray_100, _, B)
    hl("Directory", ui.blue_folder, _)
    hl("EndOfBuffer", ui.blue_800, _)
    hl("ErrorMsg", util.error, _, B)
    hl("FloatBorder", ui.gray_500, ui.gray_800)
    hl("FoldColumn", ui.gray_500, ui.gray_800)
    hl("Folded", ui.gray_500, ui.gray_800)
    hl("IncSearch", ui.brown, ui.gray_100)
    hl("LineNr", ui.gray_400, _)
    hl("lCursor", ui.green_pure, ui.green_dark)
    hl("MatchParen", ui.yellow_mid, _, U)
    hl("MatchParenCur", _, _, U)
    hl("MatchWord", _, _, U)
    hl("MatchWordCur", _, _, U)
    hl("ModeMsg", ui.gray_050, ui.gray_800)
    hl("MoreMsg", ui.copper, _)
    hl("MsgArea", ui.gray_050, _)
    hl("MsgSeparator", ui.gray_050, _)
    hl("NonText", ui.gray_400, _)
    hl("Normal", ui.gray_050, _)
    hl("NormalFloat", _, ui.gray_800)
    hl("NormalNC", ui.gray_050, _)
    hl("Pmenu", ui.gray_100, ui.gray_800)
    hl("PmenuSbar", _, ui.gray_800)
    hl("PmenuSel", _, ui.blue_900)
    hl("PmenuThumb", _, ui.gray_800)
    hl("Question", ui.copper, _)
    hl("QuickFixLine", _, ui.blue_900)
    hl("Search", ui.gray_100, ui.blue_800)
    hl("SignColumn", _, _)
    hl("SpecialKey", ui.blue_folder, _, B)
    hl("SpellBad", ui.red_500, _, U)
    hl("SpellCap", ui.yellow_light, _, U)
    hl("SpellLocal", ui.green_mid, _, U)
    hl("SpellRare", ui.magenta, _, U)
    hl("Substitute", ui.gray_100, ui.brown)
    hl("TabLine", ui.gray_100, ui.gray_700)
    hl("TabLineFill", ui.gray_700, ui.gray_700)
    hl("TabLineSel", ui.gray_050, ui.gray_700)
    hl("TermCursor", ui.green_pure, ui.green_dark)
    hl("TermCursorNC", ui.green_pure, ui.green_dark)
    hl("Title", ui.blue_folder, _, B)
    hl("TroubleIndent", ui.green_pure, ui.green_dark)
    hl("VertSplit", ui.gray_500, _)
    hl("Visual", _, ui.blue_700)
    hl("VisualNOS", _, ui.gray_800)
    hl("WarningMsg", util.error, _)
    hl("WildMenu", ui.gray_050, _)

    -- StatusLine (with extensions)
    hl("Statusline", ui.gray_400, _)
    hl("StatusLineNC", ui.gray_500, _)
    hl("SlAlt", ui.gray_050, ui.gray_700)
    hl("SlNormal", ui.black, ui.blue_note)
    hl("SlProtected", ui.black, ui.white)
    hl("SlModified", ui.black, ui.orange_intense)
    hl("SlModifiedText", ui.orange_intense, ui.black)
    hl("SlReadonly", ui.black, ui.gray_300)
    hl("SlProblem", ui.white, ui.pink_intense)
    hl("SlProblemText", ui.pink_intense, _)
    hl("SlVisual", ui.black, ui.violet)
    hl("SlSelect", ui.black, ui.magenta)
    hl("SlInsert", ui.black, ui.yellow_light)
    hl("SlReplace", ui.black, ui.pink_dark)
    hl("SlCommand", ui.black, ui.green_lime)
    hl("SlTerminal", ui.black, ui.green_lime)

    -- Diagnostics
    hl("DiagnosticError", util.error, _)
    hl("DiagnosticWarn", util.warning, _)
    hl("DiagnosticInfo", util.info, _)
    hl("DiagnosticHint", util.hint, _)
    hl("DiagnosticOk", util.success, _)

    -- Git
    hl("DiffAdd", _, util.add_950)
    hl("DiffChange", _, util.change_950)
    hl("DiffDelete", _, util.remove_950)
    hl("DiffText", _, util.add_600)
    hl("Added", util.add_300, _)
    hl("Changed", util.change_300, _)
    hl("Removed", util.remove_300, _)

    -- Cmp
    hl("SnippetTabstop", _, _, "underdotted")
    hl("CmpItemAbbr", ui.gray_050, _)
    hl("CmpItemAbbrDeprecated", ui.gray_500, _, S)
    hl("CmpItemAbbrMatch", util.info, _, B)
    hl("CmpItemAbbrMatchFuzzy", util.info_100, _)
    hl("CmpItemKindClass", syn.type_2, _)
    hl("CmpItemKindColor", syn.number, _)
    hl("CmpItemKindConstant", syn.number, _)
    hl("CmpItemKindConstructor", syn.special, _)
    hl("CmpItemKindEnum", syn.number, _)
    hl("CmpItemKindEnumMember", syn.number, _)
    hl("CmpItemKindEvent", ui.cyan_dark, _)
    hl("CmpItemKindField", syn.property, _)
    hl("CmpItemKindFile", syn.symbol, _)
    hl("CmpItemKindFolder", ui.blue_folder, _)
    hl("CmpItemKindFunction", syn.procedure, _)
    hl("CmpItemKindInterface", syn.type_1, _)
    hl("CmpItemKindKeyword", syn.keyword, _)
    hl("CmpItemKindMethod", syn.procedure, _)
    hl("CmpItemKindModule", syn.namespace, _)
    hl("CmpItemKindOperator", syn.keyword, _)
    hl("CmpItemKindProperty", syn.property, _)
    hl("CmpItemKindReference", syn.special, _)
    hl("CmpItemKindSnippet", ui.yellow_light, _)
    hl("CmpItemKindStruct", syn.type_1, _)
    hl("CmpItemKindText", syn.string, _)
    hl("CmpItemKindTypeParameter", syn.symbol, _)
    hl("CmpItemKindUnit", ui.cyan_dark, _)
    hl("CmpItemKindValue", syn.number, _)
    hl("CmpItemKindVariable", syn.symbol, _)

    -- LSP
    hl("LspReferenceRead", _, ui.blue_900)
    hl("LspReferenceText", _, ui.blue_900)
    hl("LspReferenceWrite", _, ui.blue_900)
    hl("LspInlayHint", ui.gray_300, _)
    hl("LspCodeLens", ui.gray_300, _, I)
    hl("LspCodeLensSeparator", ui.gray_300, _, I)
    hl("LspSignatureActiveParameter", util.info, _)

    -- Telescope
    hl("TelescopeSelection", util.hint, _)
    hl("TelescopeMatching", util.info, _, B)
    hl("TelescopeBorder", ui.blue_folder, ui.gray_900)

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
    hl("Statement", ui.magenta, _)
    hl("Special", syn.special, _)
    hl("Tag", syn.mark_tag, _)
    hl("Delimiter", syn.punctuation, _)
    hl("Comment", syn.comment, _, I)
    hl("SpecialComment", syn.docstring, _)
    hl("Whitespace", util.error, _) -- only unwanted whitespaces are shown
    hl("Underlined", _, _, U)
    hl("Bold", _, _, B)
    hl("Italic", _, _, I)
    hl("Ignore", ui.gray_500, _, S)
    hl("Todo", ui.green_pure, _, B)
    hl("Error", util.error, _, B)
    hl("Debug", util.debug, _)

    -- HTML
    hl("htmlTitle", syn.mark_header_1, _, B)
    hl("htmlH1", syn.mark_header_1, _, B)
    hl("htmlH2", syn.mark_header_2, _, B)
    hl("htmlH3", syn.mark_header_3, _, B)
    hl("htmlH4", syn.mark_header_4, _, B)
    hl("htmlTag", syn.punctuation, _)
    link("htmlEndTag", "htmlTag")
    hl("htmlTagName", syn.mark_tag, _)
    hl("htmlArg", syn.property, _)
    hl("htmlLink", syn.mark_emphase, _, U)
    hl("htmlSpecialChar", syn.number, _)

    -- Syntax (Treesitter)
    hl("@annotation", ui.blue_folder, _)
    hl("@attribute", syn.property, _, B, I)
    hl("@comment.docstring", syn.docstring, _)
    hl("@constant", syn.symbol, _) -- Why did I use symbol here? (2024-08-05)
    hl("@constant.builtin", syn.number, _)
    hl("@emphasis", _, _, I)
    hl("@error", util.error, _)
    link("@function.macro", "Macro")
    hl("@field", syn.property, _)
    hl("@keyword.function", syn.special, _)
    hl("@namespace", syn.namespace, _)
    hl("@parameter.reference", syn.special, _)
    hl("@property", syn.property, _)
    hl("@punctuation.bracket", syn.punctuation, _)
    hl("@punctuation.delimiter", syn.punctuation, _)
    hl("@punctuation.special", syn.punctuation, _)
    hl("@query.linter.error", util.warning, _)
    hl("@string.regex", syn.regex, _)
    hl("@string.documentation", syn.docstring, _)
    hl("@strong", ui.blue_folder, _, B)
    hl("@symbol", syn.symbol, _)
    hl("@tag.attribute", syn.property, _)
    hl("@tag.delimiter", syn.punctuation, _)
    hl("@text", syn.string, _)
    hl("@type.builtin", syn.type_2, _, B, I)
    link("@variable", "Variable")
    hl("@variable.builtin", syn.special, _)
    hl("@spell.markdown", syn.symbol, _)
    hl("@markup.heading.1.markdown", syn.mark_header_1, _, B)
    hl("@markup.heading.2.markdown", syn.mark_header_2, _, B)
    hl("@markup.heading.3.markdown", syn.mark_header_3, _, B)
    hl("@markup.heading.4.markdown", syn.mark_header_4, _, B)
    hl("@markup.raw.block.markdown", syn.bytes, _, B)
    hl("@text.title.1.marker", syn.mark_header_1, _, B)
    hl("@text.title.2.marker", syn.mark_header_2, _, B)
    hl("@text.title.3.marker", syn.mark_header_3, _, B)
    hl("@text.title.4.marker", syn.mark_header_4, _, B)
    hl("@text.title.1", syn.mark_header_1, _, B)
    hl("@text.title.2", syn.mark_header_2, _, B)
    hl("@text.title.3", syn.mark_header_3, _, B)
    hl("@text.title.4", syn.mark_header_4, _, B)
    hl("@text.bold", syn.mark_strong, _, B)
    hl("@text.italic", syn.mark_emphase, _, I)

    -- Syntax (LSP)
    hl("@lsp.type.selfKeyword", syn.special, _)
    hl("@lsp.type.selfTypeKeyword", syn.special, _, B, I)
    hl("@lsp.type.builtinType", syn.type_2, _, B, I)
    hl("@lsp.type.builtinAttribute", syn.special, _)
    -- hl("@lsp.type.typeParameter", syn.special, _)
    -- hl("@lsp.type.generic", syn.special, _)
    link("@lsp.type.decorator", "@attribute")
    link("@lsp.type.namespace", "@namespace")
    hl("@lsp.type.derive", syn.mark_emphase, _)
    link("@lsp.type.macro", "Macro")
    -- link("@lsp.type.enum", "@namespace")
    hl("@lsp.type.enum", syn.namespace, _, B, I)
    hl("@lsp.type.enumMember", syn.number, _, B, I)
    hl("@lsp.type.interface", syn.type_1, _, I)
    hl("@lsp.type.typeAlias", syn.type_2, _, I)
    hl("@lsp.type.lifetime", syn.special, _, I)
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
    filepath = filepath or vim.fn.expand("~") .. "/.vim/colors/" .. M.name .. ".vim"

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
    M.setup(gen_hi, gen_link)
    f:flush()
    f:close()
end

return M
