vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- allow project based vim setups to be run (need to manually trust them)
vim.opt.exrc = true
vim.opt.shell = "bash"
vim.opt.title = true

vim.opt.undofile = true
vim.opt.swapfile = false

-- completion menu: show menu, don't auto-insert/select, enable fuzzy matching
vim.opt.completeopt = { "menuone", "noinsert", "noselect", "fuzzy" }

-- search: case-insensitive unless uppercase is used
vim.opt.lazyredraw = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.expandtab = true

-- UI: hide mode (shown in statusline), reduce completion messages
vim.opt.shortmess:append("c")
vim.opt.showmode = false
vim.opt.laststatus = 3

vim.opt.signcolumn = "yes"

vim.opt.inccommand = "split"
vim.opt.splitbelow = true
vim.opt.splitright = true

-- trigger CursorHold events faster for LSP, autocommands
vim.opt.updatetime = 100

-- command-line completion behavior
vim.opt.wildmode = { "list:longest", "list:full" }

-- visual guides: highlight current line, show column limits
vim.opt.cursorline = true
vim.opt.colorcolumn = { "120" }

-- show invisible characters (tabs, trailing spaces)
vim.opt.list = true
vim.opt.listchars = {
  nbsp = "¬",
  extends = "»",
  precedes = "«",
  lead = " ",
  trail = "·",
  space = " ",
  tab = "▸ ",
}

-- scrolling: keep 5 lines/columns visible, no line wrapping
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.wrap = false
vim.opt.winborder = "single"

-- treat numbers after whitespace as decimal for increment/decrement
vim.opt.nrformats:append("blank")

-- multicursor: motions of the primary cursor cascade to all cursors (toggle with q=)
vim.opt.follow = true

-- LSP-based folding: start with all folds open
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = vim.lsp.foldexpr
vim.opt.foldtext = ""
vim.opt.fillchars = { fold = " ", foldsep = " ", foldinner = " " }

-- better diff algorithm for more accurate highlighting
vim.opt.diffopt:append("linematch:60")

vim.opt.spell = true
vim.opt.spelloptions = { "camel", "noplainbuffer" }

-- use ripgrep for :grep if available
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --smart-case --vimgrep --no-heading --glob=!.git --hidden --regexp"
  vim.opt.grepformat:prepend("%f:%l:%c:%m")
end

-- LSP diagnostics: show float on jump, no virtual lines
vim.diagnostic.config({
  virtual_lines = false,
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
    end,
  },
})

-- TODO: experimental feature, update accordingly to breaking changes etc.
-- this will most likely be a basic feature toggle or enabled by default
-- NOTE: to open messages use `:messages` or use `g<` also works for other pagers (like `:map` etc)
require("vim._core.ui2").enable({ enable = true, msg = { target = "msg" } })
