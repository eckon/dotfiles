" -------------------- Plugins --------------------
call plug#begin()
    " Tools
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'mattn/emmet-vim'
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
    Plug 'preservim/nerdcommenter'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-surround'
    " Syntax/Styling
    Plug 'airblade/vim-gitgutter'
    Plug 'itchyny/lightline.vim'
    Plug 'jiangmiao/auto-pairs'
    Plug 'machakann/vim-highlightedyank'
    " Color-Schemes
    Plug 'morhetz/gruvbox'
call plug#end()



" -------------------- General Setting --------------------
syntax enable
set backspace=eol,start,indent
set clipboard+=unnamedplus
set encoding=UTF-8
set hidden
set hlsearch ignorecase incsearch magic smartcase
set iskeyword+=-
set lazyredraw
set nobackup
set noerrorbells
set noshowmode
set noswapfile
set nowrap
set nowritebackup
set number relativenumber
set shiftwidth=2 tabstop=2 smarttab autoindent smartindent expandtab
set showcmd
set showmatch
set showmode
set signcolumn=yes
set splitbelow splitright
set timeoutlen=1500
set title
set updatetime=250
set whichwrap+=<,>,h,l

autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell

" Special
let g:NERDSpaceDelims=1
let g:netrw_banner=0
let g:netrw_liststyle=3



" -------------------- Color/Style Settings --------------------
colorscheme gruvbox
set background=dark
set colorcolumn=80,120,121
set cursorline
set list
set listchars=nbsp:¬,extends:»,precedes:«,trail:·,space:·,tab:▸\ 
set scrolloff=5
autocmd CursorHold * silent call CocActionAsync('highlight')



" -------------------- Key Bindings --------------------
let mapleader = "\<Space>"

" Quick escape
map <C-C> <Esc>

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
map <Leader>w- <C-W>s
map <Leader>w\| <C-W>v
map <Leader>wc <C-W>c
map <Leader>wo <C-W>o

" Use alt to resize windows
nnoremap <M-j> :resize -2<CR>
nnoremap <M-k> :resize +2<CR>
nnoremap <M-h> :vertical resize -2<CR>
nnoremap <M-l> :vertical resize +2<CR>

" Rehighlight text after indenting
vnoremap < <gv
vnoremap > >gv

" Navigating and Managing tabs
map <Leader>tn :tabnew<cr>
map <Leader>to :tabonly<cr>
map <Leader>tc :tabclose<cr>
map <Leader>tm :tabmove
map <Leader>th gT
map <Leader>tl gt

" find files, lines, content in project and open buffers
nnoremap <C-p> :GFiles<CR>
nnoremap <C-f> :BLines<CR>
nnoremap <C-_> :Ag<CR>
nnoremap <C-b> :Buffers<CR>

" quick actions for git status in the same buffer
" info: for staging, use '=', 's', 'u' and 'o' inside the status
" for more precise staging: highlight part in gitstatus with visual mode and press 's'
nmap <silent> <Leader>gs :Gedit :<CR>
nmap <Leader>gd :Gdiffsplit<CR>

map <F1> :set shiftwidth=4 tabstop=4<CR>
map <F2> :set shiftwidth=2 tabstop=2<CR>
map <F4> :w !diff % -<CR>
map <F5> :set spell<CR>
map <F6> :set nospell<CR>

" GoTo code navigation and other coc commands
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <Leader>rn <Plug>(coc-rename)
nmap <silent> <Leader>f <Plug>(coc-format)
xmap <silent> <Leader>f <Plug>(coc-format-selected)
nmap <Leader>ac <Plug>(coc-codeaction)
nmap <Leader>qf <Plug>(coc-fix-current)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Emmet map that works only in insert mode to not overwrite others in normal
imap ,, <C-Y>,



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

" Function to show documentation in a preview window
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction


"" ------------------- lightline

" Configure the status line
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'cocstatus', 'filetype', 'fileencoding', 'fileformat' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'cocstatus': 'coc#status',
      \ },
      \ }

"" ------------------- fzf.vim

" Configure the window when using fzf inside of vim (and only inside of vim)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,2"

