local set = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- allow project based vim setups to be run (need to manually trust them)
set.exrc = true
set.shell = "bash"
set.title = true

set.undofile = true
set.swapfile = false

-- completion menu: show menu, don't auto-insert/select, enable fuzzy matching
set.completeopt = { "menuone", "noinsert", "noselect", "fuzzy" }

-- search: case-insensitive unless uppercase is used
set.magic = true
set.lazyredraw = true
set.ignorecase = true
set.smartcase = true

set.number = true
set.relativenumber = true

set.shiftwidth = 2
set.tabstop = 2
set.softtabstop = 2
set.smartindent = true
set.expandtab = true

-- UI: hide mode (shown in statusline), reduce completion messages
set.shortmess:append("c")
set.showmode = false

set.signcolumn = "yes"

set.inccommand = "split"
set.splitbelow = true
set.splitright = true

-- trigger CursorHold events faster for LSP, autocommands
set.updatetime = 100

-- command-line completion behavior
set.wildmode = { "list:longest", "list:full" }

-- visual guides: highlight current line, show column limits
set.cursorline = true
set.colorcolumn = { "80", "120", "121" }

-- show invisible characters (tabs, trailing spaces)
set.list = true
set.listchars = {
  nbsp = "¬",
  extends = "»",
  precedes = "«",
  lead = " ",
  trail = "·",
  space = " ",
  tab = "▸ ",
}

-- scrolling: keep 5 lines/columns visible, no line wrapping
set.scrolloff = 5
set.sidescrolloff = 5
set.wrap = false
set.winborder = "single"

-- treat numbers after whitespace as decimal for increment/decrement
set.nrformats:append("blank")

-- LSP-based folding: start with all folds open
set.foldenable = false
set.foldlevel = 99
set.foldmethod = "expr"
set.foldexpr = "v:lua.vim.lsp.foldexpr()"
set.foldtext = ""
set.fillchars = { fold = " ", foldsep = " ", foldinner = " " }

-- better diff algorithm for more accurate highlighting
set.diffopt:append("linematch:60")

set.spell = true
set.spelloptions = { "camel", "noplainbuffer" }

-- use ripgrep for :grep if available
if vim.fn.executable("rg") == 1 then
  set.grepprg = "rg --smart-case --vimgrep --no-heading --glob=!.git --hidden --regexp"
  set.grepformat:prepend("%f:%l:%c:%m")
end

-- LSP diagnostics: show float on jump, no virtual lines
vim.diagnostic.config({
  virtual_lines = false,
  jump = { float = true },
})

-- TODO: experimental feature, update accordingly to breaking changes etc.
-- this will most likely be a basic feature toggle or enabled by default
-- NOTE: to open messages use `:messages` or use `g<` also works for other pagers (like `:map` etc)
require("vim._core.ui2").enable({ enable = true, msg = { target = "msg" } })
