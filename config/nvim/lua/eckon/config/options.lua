local set = vim.opt

vim.g.mapleader = " "

set.shell = "bash"
set.undofile = true
set.swapfile = false
set.title = true

set.completeopt = { "menuone", "noinsert", "noselect" }

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

set.splitbelow = true
set.splitright = true

set.updatetime = 100

set.wildmode = { "list:longest", "list:full" }

set.cursorline = true
set.colorcolumn = { "80", "120", "121" }

set.list = true
set.listchars = { nbsp = "¬", extends = "»", precedes = "«", lead = " ", trail = "·", space = " ", tab = "▸ " }
set.fillchars = { fold = " " }

set.scrolloff = 5
set.sidescrolloff = 5
set.wrap = false

set.winbar = "%t %m"

set.foldenable = false
set.foldlevel = 99
set.foldmethod = "expr"

-- on gigantic files this is slowing down vim alot, so ignore in minimal mode
if not require("eckon.utils").run_minimal() then
  set.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  -- manually extending "v:lua.vim.treesitter.foldtext()"
  set.foldtext = "v:lua.require('eckon.utils').foldtext()"
end

set.diffopt:append("linematch:60")

set.spell = true
set.spelloptions = { "camel", "noplainbuffer" }

if vim.fn.executable("rg") == 1 then
  set.grepprg = "rg --smart-case --vimgrep --no-heading --glob=!.git --hidden --regexp"
  set.grepformat:prepend("%f:%l:%c:%m")
end
