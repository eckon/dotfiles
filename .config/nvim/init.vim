" -------------------- Plugin Installations {{{1
call plug#begin()
  " General Tools {{{2
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'

  " Try out (not sure yet if I want to keep them)
  Plug 'phaazon/hop.nvim'

  " Treesitter {{{2
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'

  " LSP - base {{{2
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/nvim-lsp-installer'
  " LSP - completion
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  " LSP - snippet
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'rafamadriz/friendly-snippets'
  " LSP - extensions
  Plug 'jose-elias-alvarez/null-ls.nvim'

  " Syntax/Styling/Appearance/Special {{{2
  Plug 'gruvbox-community/gruvbox'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'tmux-plugins/vim-tmux-focus-events'
  " }}}2
call plug#end()



" -------------------- General Configuration {{{1
let mapleader = "\<Space>"

syntax enable
filetype plugin on

set autoread
set backspace=eol,start,indent
set clipboard+=unnamedplus
set completeopt=menuone,noinsert,noselect
set foldmethod=indent nofoldenable
set hidden
set hlsearch ignorecase incsearch magic smartcase
set inccommand=nosplit
set lazyredraw
set mouse=a
set nobackup nowritebackup noswapfile undofile
set noerrorbells
set nowrap
set number relativenumber
set shell=bash
set shiftwidth=2 tabstop=2 softtabstop=2 smarttab autoindent smartindent expandtab
set shortmess+=c
set showcmd noshowmode
set signcolumn=yes
set splitbelow splitright
set timeoutlen=1000 updatetime=100
set title
set wildmode=list:longest,list:full

" enable embedded script highlighting of lua code
let g:vimsyn_embed = 'l'



" -------------------- Color/Style Configuration {{{1
if has('termguicolors')
  set termguicolors
endif

colorscheme gruvbox
set background=dark
set cursorline colorcolumn=80,120,121
set list listchars=nbsp:¬,extends:»,precedes:«,lead:\ ,trail:·,space:\ ,tab:▸\ 
set scrolloff=5

augroup HighlightYankedText
  autocmd!
  autocmd TextYankPost * silent! lua require('vim.highlight').on_yank()
augroup END



" -------------------- General Key Bindings / Commands {{{1
" ---------- Custom Key Bindings {{{2
" disable annoying keys
nnoremap Q <Nop>
nnoremap <F1> <Nop>
inoremap <F1> <Nop>

" make Y behave like other upper case commands (yank from start to end)
nnoremap Y y$

" rehighlight text after indenting
vnoremap < <gv
vnoremap > >gv

" append jump-commands for quickfix-list jumps
nnoremap [q <CMD>cprevious<CR>zz
nnoremap ]q <CMD>cnext<CR>zz
nnoremap [Q <CMD>cfirst<CR>zz
nnoremap ]Q <CMD>clast<CR>zz

" extend redraw of screen with hiding the highlight of search results
nnoremap <C-l> <CMD>nohlsearch<BAR>diffupdate<CR><C-l>

" quickly update macro - use wanted register - press enter to execute
nnoremap <Leader>m :<C-u><C-r><C-r>='let @'. v:register .' = '. string(getreg(v:register))<CR><C-f><LEFT>



" ---------- Custom Commands {{{2
" open current buffer file in the browser (needs to be cloned over git with ssh)
command! CCOpenProjectInBrowser
  \ !xdg-open $(
  \   git config --get remote.origin.url
  \     | sed 's/\.git//g'
  \     | sed 's/:/\//g'
  \     | sed 's/git@/https:\/\//'
  \ )/blob/$(
  \   git branch --show-current
  \ )/%

" open current project and goto the current buffer file in vscode
command! CCOpenProjectInVsCode !code $(pwd) -g %

" fill quickfix with errors, do some formatting to have correct quickfix format
" path:line:col:message
command! CCRunEslint cexpr system("npx eslint -f unix '{src,apps}/**/*.ts' 2>/dev/null | awk 'length($0) > 20 { print $0 }'")
command! CCRunTsc    cexpr system("npx tsc 2>/dev/null | sed 's/[(,]/:/g' | sed 's/)//'")

" git blame of current line
command! CCGitBlameLine execute "!git blame -L " .. line('.') .. "," .. line('.') .. " -- %"



" -------------------- Plugin Configurations {{{1
" ---------- Language Server Protocol (LSP) {{{2
" ----- Configurations {{{3
lua << EOF
local nvim_lsp = require('lspconfig')
local lsp_installer = require('nvim-lsp-installer')
local cmp = require('cmp')
local null_ls = require('null-ls')

local servers = {
  'bashls',
  'cssls',
  'emmet_ls',
  'eslint',
  'html',
  'jsonls',
  'tailwindcss',
  'tsserver',
  'vimls',
  'vuels',
  'yamlls',
}

-- install servers if not already existing
for _, name in pairs(servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found then
    if not server:is_installed() then
      print('Installing ' .. name)
      server:install()
    end
  end
end


-- setup null-ls
null_ls.setup({ sources = {
  null_ls.builtins.formatting.prettier,
}})

-- setup nvim-cmp
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn['vsnip#available'](1) == 1 then
        feedkey('<Plug>(vsnip-expand-or-jump)', '')
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        feedkey('<Plug>(vsnip-jump-prev)', '')
      end
    end, { 'i', 's' }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
    { name = 'path' },
  }, { { name = 'buffer' }, }),
})

-- setup lspconfig and the installer
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- this also handles the basic nvim_lsp setup (which can be ignored here)
lsp_installer.on_server_ready(function(server)
  local opts = { capabilities = capabilities }
  server:setup(opts)
end)
EOF


" ----- Mappings {{{3
nnoremap <silent>K :call <SID>show_documentation()<CR>
nnoremap <C-k> <CMD>lua vim.lsp.buf.signature_help()<CR>
inoremap <C-k> <CMD>lua vim.lsp.buf.signature_help()<CR>

nnoremap gd <CMD>lua vim.lsp.buf.definition()<CR>
nnoremap gD <CMD>lua vim.lsp.buf.declaration()<CR>
nnoremap gr <CMD>lua vim.lsp.buf.references()<CR>
nnoremap gi <CMD>lua vim.lsp.buf.implementation()<CR>
nnoremap [g <CMD>lua vim.diagnostic.goto_prev()<CR>
nnoremap ]g <CMD>lua vim.diagnostic.goto_next()<CR>

nnoremap <Leader>la <CMD>lua vim.lsp.buf.code_action()<CR>
nnoremap <Leader>lr <CMD>lua vim.lsp.buf.rename()<CR>
nnoremap <Leader>lf <CMD>lua vim.lsp.buf.formatting()<CR>
vnoremap <silent><Leader>lf :lua vim.lsp.buf.range_formatting()<CR>

" use default K if we have something in help
function! s:show_documentation() abort
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h ' . expand('<cword>')
  else
    execute 'lua vim.lsp.buf.hover()'
  endif
endfunction



" ---------- Treesitter {{{2
" ----- Configurations {{{3
lua << EOF
require('nvim-treesitter.configs').setup({
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
    -- regex highlight is still better than TS highlight
    disable = { 'php', 'vim' },
  },
  context_commentstring = { enable = true },
})
EOF



" ---------- Fuzzy-Finder {{{2
" ----- Configurations {{{3
" enable to use ctrl-p/n in fzf window to cycle through history
let g:fzf_history_dir = '~/.local/share/fzf-history'


" ----- Mappings {{{3
" show all files of <range> parents folders from current file
nnoremap <Leader>f. <CMD>call fzf#vim#files(expand("%:p" . repeat(":h", v:count1)))<CR>
nnoremap <Leader>fa :Ag<Space>
nnoremap <Leader>fb <CMD>Buffers<CR>
nnoremap <Leader>ff <CMD>GFiles<CR>
nnoremap <Leader>fg <CMD>GFiles?<CR>
nnoremap <Leader>fl <CMD>BLines<CR>



" ---------- Git {{{2
" ----- Configurations {{{3
lua << EOF
require('gitsigns').setup({ keymaps = {} })
EOF


" ----- Mappings {{{3
nnoremap <Leader>gb <CMD>lua require'gitsigns'.blame_line{full=true}<CR>
nnoremap ]c <CMD>Gitsigns next_hunk<CR>
nnoremap [c <CMD>Gitsigns prev_hunk<CR>



" ---------- Statusline {{{2
" ----- Configurations {{{3
lua << EOF
local lsp_count = function()
  local error_table = vim.diagnostic.get(0, { severity = { min = vim.diagnostic.severity.WARN } })
  local info_table = vim.diagnostic.get(0, { severity = { max = vim.diagnostic.severity.INFO } })

  local error_count, info_count = 0, 0
  for _ in pairs(error_table) do error_count = error_count + 1 end
  for _ in pairs(info_table)  do info_count  = info_count  + 1 end

  local status = ''
  if error_count > 0 then status = status .. error_count .. '[!] ' end
  if info_count  > 0 then status = status .. info_count  .. '[?] ' end

  -- remove last character (padding space)
  status = status:sub(1, -2)

  return status
end

require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = 'gruvbox',
    component_separators = {},
    section_separators = {},
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { 'filename' },
    lualine_x = { lsp_count, 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  }
})
EOF



" ---------- Filetree {{{2
" ----- Configurations {{{3
let g:nvim_tree_quit_on_open = 1
let g:nvim_tree_add_trailing = 1
let g:nvim_tree_group_empty = 1
let g:nvim_tree_show_icons = {
  \   'git': 0,
  \   'folders': 0,
  \   'files': 0,
  \   'folder_arrows': 0,
  \ }

lua << EOF
require('nvim-tree').setup({
  git = { ignore = false },
  view = { hide_root_folder = true, width = '20%' },
})
EOF


" ----- Mappings {{{3
nnoremap <Leader>. <CMD>NvimTreeFindFileToggle<CR>
nnoremap <Leader>, <CMD>NvimTreeToggle<CR>



" ---------- hop {{{2
" ----- Configurations {{{3
lua << EOF
require('hop').setup()
EOF


" ----- Mappings {{{3
noremap H <CMD>HopChar1<CR>

" vim:foldmethod=marker
