--  INFO: :help option-list

vim.g.disable_rainbow_statusline = 1
vim.g.have_nerd_font = true
vim.g.omni_sql_no_default_maps = 1 -- prevent generation of special keymaps for *.sql files

vim.opt.termguicolors = true
vim.opt.title = true
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.updatetime = 5000 -- Milliseconds of inactivity before creating a change
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.laststatus = 3 -- Only one status line per window
vim.opt.mouse = "a"

vim.opt.guicursor = "n-v-sm:block,i-c-ci-ve:ver25,r-cr-o:hor20,a:Cursor"
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmode = false
vim.opt.signcolumn = "yes"

vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.scrolloff = 5 -- Min visible lines above and under cursor
-- vim.opt.lazyredraw = true      -- Improve scrolling a lot (no redraw during maccros)

vim.opt_global.matchpairs:append("<:>")

-- Search and replace
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = false
vim.opt.inccommand = "nosplit"
vim.opt.grepprg = "rg --vimgrep --smart-case"

vim.opt.wildmode = "list:lastused:longest"
vim.opt.diffopt = "internal,filler,closeoff,vertical"

-- Indentation
vim.opt.autoindent = false
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.foldmethod = "manual"
vim.opt.foldlevelstart = 99

if vim.fn.has("wsl") then
    vim.g.clipboard = {
        name = "WSL Clipboard",
        copy = { ["+"] = "wcopy", ["*"] = "wcopy" },
        paste = { ["+"] = "wpaste", ["*"] = "wpaste" },
        cache_enabled = false,
    }
end
