" -------------------- Plugin Installations
call plug#begin()
  " General Tools
  Plug 'ibhagwan/fzf-lua', { 'branch': 'main' }
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'phaazon/hop.nvim'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-sleuth'
  Plug 'tpope/vim-surround'

  " Treesitter
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'

  " LSP
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }

  " Syntax/Styling/Appearance/Special
  Plug 'ellisonleao/gruvbox.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'tmux-plugins/vim-tmux-focus-events'
call plug#end()



" -------------------- General Configuration
let mapleader = "\<Space>"

set clipboard+=unnamedplus shell=bash mouse=a undofile noswapfile title
set completeopt=menuone,noinsert,noselect
set magic lazyredraw ignorecase smartcase
set number relativenumber
set shiftwidth=2 tabstop=2 softtabstop=2 smartindent expandtab
set shortmess+=c noshowmode
set signcolumn=yes
set splitbelow splitright
set updatetime=100
set wildmode=list:longest,list:full



" -------------------- Color/Style Configuration
colorscheme gruvbox

set cursorline colorcolumn=80,120,121
set list listchars=nbsp:¬,extends:»,precedes:«,lead:\ ,trail:·,space:\ ,tab:▸\ 
set scrolloff=5 sidescrolloff=5 nowrap
set termguicolors
set winbar=%t\ %m

set foldlevelstart=99 fillchars=fold:\ 
set foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
set foldtext=substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend))



" -------------------- Autocommands
augroup HighlightYankedText
  autocmd!
  autocmd TextYankPost * silent! lua require('vim.highlight').on_yank()
augroup END

augroup RestoreCursor
  autocmd!
  autocmd BufReadPost *
    \ if &ft !~# 'commit\|rebase' && line("'\"") >= 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif
augroup END

augroup ResourceConfigOnSave
  autocmd!
  execute "autocmd BufWritePost " . expand("$MYVIMRC") . " source <sfile>"
augroup END



" -------------------- General Key Bindings / Commands
" ---------- Custom Key Bindings
" disable annoying keys
nnoremap <F1> <Nop>
inoremap <F1> <Nop>
noremap U <Nop>

" rehighlight text after indenting
vnoremap < <gv
vnoremap > >gv

" append jump-commands for quickfix-list jumps
nnoremap [q <CMD>cprevious<CR>zz
nnoremap ]q <CMD>cnext<CR>zz
nnoremap [Q <CMD>cfirst<CR>zz
nnoremap ]Q <CMD>clast<CR>zz

" quickly update macro - use wanted register - press enter to execute
nnoremap <Leader>m :<C-u><C-r><C-r>='let @' . v:register . ' = ' . string(getreg(v:register))<CR><C-f><LEFT>

" custom textobject for indentations
onoremap <silent> ii :lua require('textobjects').indent_inner_textobject()<CR>
xnoremap <silent> ii :<C-u>lua require('textobjects').indent_inner_textobject()<CR>
onoremap <silent> ai :lua require('textobjects').indent_around_textobject()<CR>
xnoremap <silent> ai :<C-u>lua require('textobjects').indent_around_textobject()<CR>



" ---------- Custom Commands
" quickly setup vim for pair programming
command! CCPairProgramming tabdo windo set norelativenumber

" open current buffer file in the browser (needs to be cloned over git with ssh)
command! CCBrowser
  \ !xdg-open $(
  \   git config --get remote.origin.url
  \     | sed 's/\.git//g'
  \     | sed 's/:/\//g'
  \     | sed 's/git@/https:\/\//'
  \ )/$(
  \   git config --get remote.origin.url | grep -q 'bitbucket.org'
  \     && echo 'src/master'
  \     || echo blob/$(git branch --show-current)
  \ )/%

" open current project and goto the current buffer file in vscode
command! CCVSCode !code $(pwd) -g %



" -------------------- Plugin Configurations
" ---------- Language Server Protocol (LSP)
" ----- Configurations
" set coc extensions that should always be installed
" essential
let g:coc_global_extensions = [
  \   'coc-marketplace',
  \ ]
" general
let g:coc_global_extensions += [
  \   'coc-docker',
  \   'coc-html',
  \   'coc-json',
  \   'coc-vimlsp',
  \   'coc-yaml',
  \ ]
" specific
let g:coc_global_extensions += [
  \   'coc-css',
  \   'coc-emmet',
  \   'coc-eslint8',
  \   'coc-prettier',
  \   'coc-sumneko-lua',
  \   'coc-toml',
  \   'coc-tsserver',
  \   'coc-vetur',
  \ ]


" ----- Mappings
nnoremap <silent>K :call <SID>show_documentation()<CR>
inoremap <silent><expr> <C-Space> coc#refresh()

nmap <silent>[d <Plug>(coc-diagnostic-prev)
nmap <silent>]d <Plug>(coc-diagnostic-next)
nmap <silent>gd <Plug>(coc-definition)
nmap <silent>gD <Plug>(coc-type-definition)
nmap <silent>gr <Plug>(coc-references-used)

nmap <silent><Leader>la <Plug>(coc-codeaction)
nmap <silent><Leader>lr <Plug>(coc-rename)
nmap <silent><Leader>lf <Plug>(coc-format)
xmap <silent><Leader>lf <Plug>(coc-format-selected)

" use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" use <CR> to confirm completion
if exists('*complete_info')
  inoremap <expr> <CR> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<CR>"
else
  imap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
endif

function! s:show_documentation() abort
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'h ' . expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . ' ' . expand('<cword>')
  endif
endfunction



" ---------- Treesitter
" ----- Configurations
lua << EOF
require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  highlight = {
    enable = true,
    -- regex highlight is still better than Treesitter highlight
    disable = { 'php', 'vim' },
  },
  context_commentstring = { enable = true },
})
EOF



" ---------- Fuzzy-Finder
" ----- Configurations
lua << EOF
-- allow history search with ctrl-n and ctrl-p
local share_dir = vim.fn.expand('~/.local/share')
require('fzf-lua').setup({
  fzf_opts = { ['--history'] = share_dir .. '/' .. 'fzf-vim-history' },
  previewers = { git_diff = { pager = 'delta' } },
})
EOF


" ----- Mappings
nnoremap <Leader>fa <CMD>lua require('fzf-lua').grep()<CR>
nnoremap <Leader>fr <CMD>lua require('fzf-lua').resume()<CR>
nnoremap <Leader>fb <CMD>lua require('fzf-lua').buffers()<CR>
nnoremap <Leader>ff <CMD>lua require('fzf-lua').files()<CR>
nnoremap <Leader>fg <CMD>lua require('fzf-lua').git_status()<CR>
nnoremap <Leader>fl <CMD>lua require('fzf-lua').blines()<CR>
nnoremap <Leader>fh <CMD>lua require('fzf-lua').help_tags()<CR>



" ---------- Git
" ----- Configurations
lua << EOF
require('gitsigns').setup({ keymaps = {} })
EOF


" ----- Mappings
nnoremap <Leader>gb <CMD>lua require('gitsigns').blame_line({ full = true })<CR>
nnoremap <Leader>gq <CMD>lua require('gitsigns').setqflist('all')<CR>

nnoremap ]c <CMD>Gitsigns next_hunk<CR>zz
nnoremap [c <CMD>Gitsigns prev_hunk<CR>zz



" ---------- Statusline
" ----- Configurations
lua << EOF
require('lualine').setup({
  options = {
    component_separators = {},
    globalstatus = true,
    section_separators = {},
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { 'coc#status' },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
})
EOF



" ---------- Filetree
" ----- Configurations
lua << EOF
require('nvim-tree').setup({
  actions = { open_file = { quit_on_open = true } },
  git = { ignore = false },
  renderer = {
    add_trailing = true,
    group_empty = true,
  },
  view = {
    adaptive_size = true,
    hide_root_folder = true,
    relativenumber = true,
  },
})
EOF


" ----- Mappings
nnoremap <Leader>. <CMD>NvimTreeFindFileToggle<CR>



" ---------- hop
" ----- Configurations
lua << EOF
require('hop').setup()
EOF


" ----- Mappings
noremap H <CMD>HopChar1<CR>
