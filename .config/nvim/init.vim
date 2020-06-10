" -------------------- Plugins --------------------
call plug#begin()
    " Tools
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
    Plug 'preservim/nerdcommenter'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-surround'
    " Syntax/Styling
    Plug 'airblade/vim-gitgutter'
    Plug 'itchyny/lightline.vim'
    Plug 'jiangmiao/auto-pairs'
    Plug 'luochen1990/rainbow'
    Plug 'machakann/vim-highlightedyank'
    " Color-Schemes
    Plug 'morhetz/gruvbox'
call plug#end()



" -------------------- General Setting --------------------
syntax on
set backspace=eol,start,indent
set clipboard+=unnamedplus
set encoding=UTF-8
set expandtab
set hidden
set hlsearch
set ignorecase
set incsearch
set lazyredraw
set magic
set nobackup
set noshowmode
set noswapfile
set nowritebackup
set number relativenumber
set showcmd
set showmatch
set showmode
set signcolumn=yes
set smartcase
set shiftwidth=4 tabstop=4 smarttab autoindent smartindent
set timeoutlen=5000
set title
set whichwrap+=<,>,h,l
let g:rainbow_active = 1
let g:NERDSpaceDelims = 1



" -------------------- Key Bindings --------------------
let mapleader = " "

" Quick safe for different vim modes
nmap <C-S> :w<CR>
vmap <C-S> <Esc><C-s>gv
imap <C-S> <Esc><C-S>

" Moving between and Resizing windows
map <Leader>wj <C-W>j
map <Leader>wk <C-W>k
map <Leader>wh <C-W>h
map <Leader>wl <C-W>l
map <Leader>wf <C-W>_<C-W>\|
map <Leader>we <C-W>=
map <Leader>w- <C-W>s<C-W>j
map <Leader>w\| <C-W>v<C-W>l
map <Leader>wc <C-W>c
map <Leader>wo <C-W>o
nnoremap <Up> :resize +2<CR>
nnoremap <Down> :resize -2<CR>
nnoremap <Left> :vertical resize -2<CR>
nnoremap <Right> :vertical resize +2<CR>

" Navigating and Managing tabs
map <Leader>tn :tabnew<cr>
map <Leader>to :tabonly<cr>
map <Leader>tc :tabclose<cr>
map <Leader>tm :tabmove
map <Leader>th gT
map <Leader>tl gt

" Quickly insert an empty new line without entering insert mode
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

" find files, lines, content in project and open buffers
nnoremap <C-p> :GFiles<CR>
nnoremap <C-f> :BLines<CR>
nnoremap <C-_> :Ag<CR>
nnoremap <C-b> :Buffers<CR>

" quick actions for git status and then max window size
" info: for staging, use '=', 's', 'u' and 'o' inside the status
" for more precise staging: ':Gdiff' -> visual select -> ':diffput'
nmap <Leader>gs :G<CR><C-W>_

map <F1> :set shiftwidth=4 tabstop=4<CR>
map <F2> :set shiftwidth=2 tabstop=2<CR>

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)



" -------------------- Color/Style Settings --------------------
colorscheme gruvbox
set background=dark
set cursorline
set colorcolumn=120
set scrolloff=5
set listchars=nbsp:¬,extends:»,precedes:«,tab:▸\ ,trail:·
set list
autocmd CursorHold * silent call CocActionAsync('highlight')



" -------------------- Plugin Specific Settings --------------------


"" ------------------- coc.nvim

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif


"" ------------------- lightline

" configure the status line (add git branch)
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

