local set = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- allow project based vim setups to be run (need to manually trust them)
set.exrc = true
set.shell = "bash"
set.undofile = true
set.swapfile = false
set.title = true

set.completeopt = { "menuone", "noinsert", "noselect", "fuzzy" }

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

set.shortmess:append("c")
set.showmode = false

set.signcolumn = "yes"

set.inccommand = "split"
set.splitbelow = true
set.splitright = true

set.updatetime = 100

set.wildmode = { "list:longest", "list:full" }

set.cursorline = true
set.colorcolumn = { "80", "120", "121" }

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

set.scrolloff = 5
set.sidescrolloff = 5
set.wrap = false
set.winborder = "single"

-- basic lsp based folding, improved via `snacks.statuscolumn`
set.foldenable = false
set.foldlevel = 99
set.foldmethod = "expr"
set.foldexpr = "v:lua.vim.lsp.foldexpr()"
set.foldtext = ""
set.fillchars = { fold = " ", foldsep = " ", foldinner = " " }

set.diffopt:append("linematch:60")

set.spell = true
set.spelloptions = { "camel", "noplainbuffer" }

if vim.fn.executable("rg") == 1 then
  set.grepprg = "rg --smart-case --vimgrep --no-heading --glob=!.git --hidden --regexp"
  set.grepformat:prepend("%f:%l:%c:%m")
end

vim.diagnostic.config({
  virtual_lines = false,
  -- open float on default jump bindings ([d and ]d)
  jump = { float = true },
})

-- TODO: experimental feature, update accordingly to breaking changes etc.
-- this will most likely be a basic feature toggle or enabled by default
-- TODO: future should allow overwrite of messages, to not spam them, wait until we see how to do so
--       seems to be possible as internal tools like package update, already do that
require("vim._extui").enable({ enable = true, msg = { target = "msg" } })
