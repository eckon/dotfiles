" -------------------- Plugin Installations {{{1
call plug#begin()
  " Tools {{{2
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'preservim/nerdtree'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'


  " Try out (not sure yet if I want to keep them)
  Plug 'mfussenegger/nvim-treehopper'
  Plug 'phaazon/hop.nvim'
  Plug 'puremourning/vimspector'


  " LSP / Snippets / LSP-Enhancements
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/nvim-lsp-installer'

  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'

  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'rafamadriz/friendly-snippets'

  Plug 'tami5/lspsaga.nvim'
  Plug 'ray-x/lsp_signature.nvim'


  " Syntax/Styling/Appearance/Special {{{2
  Plug 'gruvbox-community/gruvbox'
  Plug 'mhinz/vim-signify'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
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



" -------------------- General Key Bindings / Commands / Abbreviations {{{1
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
command! OpenProjectInBrowser
  \ !xdg-open $(
  \   git config --get remote.origin.url
  \     | sed 's/\.git//g'
  \     | sed 's/:/\//g'
  \     | sed 's/git@/https:\/\//'
  \ )/blob/$(
  \   git branch --show-current
  \ )/%

" open current project and goto the current buffer file in vscode
command! OpenProjectInVsCode !code $(pwd) -g %

" fill quickfix with errors, do some formatting to have correct quickfix format
" path:line:col:message
command! RunEslint cexpr system("npx eslint -f unix '{src,apps}/**/*.ts' 2>/dev/null | awk 'length($0) > 20 { print $0 }'")
command! RunTsc    cexpr system("npx tsc 2>/dev/null | sed 's/[(,]/:/g' | sed 's/)//'")



" -------------------- Plugin Configurations {{{1
" ---------- LSP {{{2
" ----- Configurations {{{3
lua << EOF
local nvim_lsp = require('lspconfig')
local lsp_installer = require('nvim-lsp-installer')
local cmp = require('cmp')
local lspsaga = require('lspsaga')

local servers = {
  'tsserver',
  'tailwindcss',
  'yamlls',
  'html',
  'emmet_ls',
  'vuels',
}


-- setup lsp_signature
require('lsp_signature').setup({
  bind = true,
  floating_window = false,
})


-- setup lspsaga
lspsaga.setup{}


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


-- setup lsp_installer
lsp_installer.on_server_ready(function(server)
    local opts = {}
    server:setup(opts)
end)


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


-- setup lspconfig with the final general lsp setup
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end
EOF


" ----- Mappings {{{3
nnoremap <silent>K :call <SID>show_documentation()<CR>
nnoremap <C-k> <CMD>Lspsaga signature_help<CR>
inoremap <C-k> <CMD>Lspsaga signature_help<CR>

nnoremap gd <CMD>lua vim.lsp.buf.definition()<CR>
nnoremap gD <CMD>lua vim.lsp.buf.declaration()<CR>
nnoremap gr <CMD>lua vim.lsp.buf.references()<CR>
nnoremap gi <CMD>lua vim.lsp.buf.implementation()<CR>
nnoremap [g <CMD>Lspsaga diagnostic_jump_prev<CR>
nnoremap ]g <CMD>Lspsaga diagnostic_jump_next<CR>

nnoremap <Leader>la <CMD>Lspsaga code_action<CR>
nnoremap <Leader>lr <CMD>Lspsaga rename<CR>
nnoremap <Leader>lf <CMD>lua vim.lsp.buf.formatting()<CR>
vnoremap <silent><Leader>lf :lua vim.lsp.buf.range_formatting()<CR>

" use default K if we have something in help
function! s:show_documentation() abort
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h ' . expand('<cword>')
  else
    execute 'Lspsaga hover_doc'
  endif
endfunction



" ---------- hop {{{2
" ----- Configurations {{{3
lua << EOF
require('hop').setup()
EOF


" ----- Mappings {{{3
noremap H <CMD>HopChar1<CR>



" ---------- lualine {{{2
" ----- Configurations {{{3
lua << EOF
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
    lualine_x = { 'lsp_count()', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  }
})

function lsp_count()
  local error_table = vim.diagnostic.get(0, { severity = { min = vim.diagnostic.severity.WARN } })
  local info_table = vim.diagnostic.get(0, { severity = { max = vim.diagnostic.severity.INFO } })

  local error_count = 0
  for _ in pairs(error_table) do
    error_count = error_count + 1
  end

  local info_count = 0
  for _ in pairs(info_table) do
    info_count = info_count + 1
  end

  local status = ''
  if error_count > 0 then
    status = status .. error_count .. '[!] '
  end

  if info_count > 0 then
    status = status .. info_count .. '[?] '
  end

  -- remove last character (this is a not needed padding space)
  status = status:sub(1, -2)

  return status
end
EOF



" ---------- NERDTree {{{2
" ----- Configurations {{{3
let NERDTreeShowHidden = 1
let NERDTreeQuitOnOpen = 1


" ----- Mappings {{{3
nnoremap <Leader>. <CMD>NERDTreeFind<CR>
nnoremap <Leader>, <CMD>NERDTree<CR>



" ---------- nvim-treehopper {{{2
" ----- Mappings {{{3
omap <silent> m :<C-U>lua require('tsht').nodes()<CR>
vnoremap <silent> m :lua require('tsht').nodes()<CR>



" ---------- nvim-treesitter {{{2
" ----- Configurations {{{3
lua << EOF
require('nvim-treesitter.configs').setup({
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
    -- regex highlight is still better than TS highlight
    disable = { 'php', 'vim' },
  },
})
EOF



" ---------- Fuzzy-Search (fzf.vim) {{{2
" ----- Configurations {{{3
" enable to use ctrl-p/n in fzf window to cycle through history
let g:fzf_history_dir = '~/.local/share/fzf-history'


" ----- Mappings {{{3
nnoremap <Leader><TAB> <CMD>Commands<CR>
" show all files of <range> parents folders from current file
nnoremap <Leader>f. <CMD>call fzf#vim#files(expand("%:p" . repeat(":h", v:count1)))<CR>
nnoremap <Leader>fa :Ag<Space>
nnoremap <Leader>fb <CMD>Buffers<CR>
nnoremap <Leader>ff <CMD>GFiles<CR>
nnoremap <Leader>fg <CMD>GFiles?<CR>
nnoremap <Leader>fl <CMD>BLines<CR>



" ---------- vimspector {{{2
" ----- Configurations {{{3
let g:vimspector_install_gadgets = [ 'vscode-node-debug2' ]


" ----- Mappings {{{3
nnoremap <Leader>dd <CMD>call vimspector#Launch()<CR>
nnoremap <Leader>ds <CMD>call vimspector#Reset()<CR>
nnoremap <Leader>dc <CMD>call vimspector#Continue()<CR>
nnoremap <Leader>dC <CMD>call vimspector#RunToCursor()<CR>
nnoremap <Leader>dr <CMD>call vimspector#Restart()<CR>

nnoremap <Leader>dt <CMD>call vimspector#ToggleBreakpoint()<CR>
nnoremap <Leader>dT <CMD>call vimspector#ClearBreakpoints()<CR>

nnoremap <Leader>dl <CMD>call vimspector#StepOut()<CR>
nnoremap <Leader>dh <CMD>call vimspector#StepInto()<CR>
nnoremap <Leader>dj <CMD>call vimspector#StepOver()<CR>

nmap <leader>di <Plug>VimspectorBalloonEval
xmap <leader>di <Plug>VimspectorBalloonEval

" vim:foldmethod=marker
