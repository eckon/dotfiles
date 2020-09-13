" -------------------- Plugins --------------------
call plug#begin()
  " Tools
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'mbbill/undotree'
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
  Plug 'preservim/nerdcommenter'
  Plug 'preservim/nerdtree' " use only for easy exploring and renaming/moving folder/file structures
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'
  " Syntax/Styling/Appearance
  Plug 'airblade/vim-gitgutter'
  Plug 'itchyny/lightline.vim'
  Plug 'morhetz/gruvbox'
  Plug 'psliwka/vim-smoothie'
  " Special (compatibility/others)
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }
  Plug 'tmux-plugins/vim-tmux-focus-events'
call plug#end()



" -------------------- General Setting --------------------
syntax enable
filetype plugin on

set backspace=eol,start,indent
set clipboard+=unnamedplus
set encoding=UTF-8
set hidden
set hlsearch ignorecase incsearch magic smartcase
set lazyredraw
set nobackup nowritebackup noswapfile
set noerrorbells
set noshowmode
set nowrap
set number relativenumber
set shiftwidth=2 tabstop=2 softtabstop=2 smarttab autoindent smartindent expandtab
set showcmd
set showmatch
set showmode
set signcolumn=yes
set splitbelow splitright
set timeoutlen=1500
set title
set undofile
set updatetime=250
set whichwrap+=<,>,h,l

" special
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1
let g:NERDSpaceDelims=1
let g:netrw_banner=0
let g:netrw_liststyle=3

" reload buffer when file changed from outside
set autoread
autocmd FocusGained,BufEnter * checktime



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

" quick escape
map <C-c> <ESC>

" disable vim ex mode
nmap Q <Nop>

" quick safe for different vim modes
nmap <C-s> :w<CR>
vmap <C-s> <ESC><C-s>gv
imap <C-s> <ESC><C-s>

" moving between and Resizing windows (eqiuvalent to <Ctrl-W>)
map <silent> <Leader>wj :wincmd j<CR>
map <silent> <Leader>wk :wincmd k<CR>
map <silent> <Leader>wh :wincmd h<CR>
map <silent> <Leader>wl :wincmd l<CR>
map <silent> <Leader>wf :wincmd _ \| :wincmd \|<CR>
map <silent> <Leader>we :wincmd =<CR>
map <silent> <Leader>w- :wincmd s<CR>
map <silent> <Leader>w\| :wincmd v<CR>
map <silent> <Leader>wc :wincmd c<CR>
map <silent> <Leader>wo :wincmd o<CR>

" use alt to resize windows
nnoremap <M-j> :resize -2<CR>
nnoremap <M-k> :resize +2<CR>
nnoremap <M-h> :vertical resize -2<CR>
nnoremap <M-l> :vertical resize +2<CR>

" rehighlight text after indenting
vnoremap < <gv
vnoremap > >gv

" navigating and Managing tabs
map <Leader>tn :tabnew<CR>
map <Leader>to :tabonly<CR>
map <Leader>tc :tabclose<CR>
map <Leader>tm :tabmove
map <Leader>th gT
map <Leader>tl gt

" find files, lines, content in project and open buffers
nnoremap <C-p> :GFiles<CR>
nnoremap <C-f> :BLines<CR>
nnoremap <C-_> :Ag<CR>
nnoremap <C-b> :Buffers<CR>

" quick actions for git status in the same buffer
nmap <silent> <Leader>gs :Gedit :<CR>
nmap <Leader>gd :Gdiffsplit<CR>
" quick actions for git merge conflicts left side 'f' (merge into) right 'j'
nmap <Leader>gf :diffget //2<CR>
nmap <Leader>gj :diffget //3<CR>

map <F1> :set shiftwidth=4 tabstop=4 softtabstop=4<CR>
map <F2> :set shiftwidth=2 tabstop=2 softtabstop=2<CR>
map <F4> :w !diff % -<CR>
map <F5> :set spell<CR>
map <F6> :set nospell<CR>

" goto code navigation and other coc commands
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

" use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" nerdtree map for easy use
map <silent><C-n> :NERDTreeToggle<CR>

" toggle undotree and focus when it is open
map <silent> <Leader>u :UndotreeToggle \| UndotreeFocus<CR>



" -------------------- Plugin Specific Settings --------------------

"" ------------------- coc.nvim

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

" use <C-space> to trigger completion.
inoremap <silent><expr> <C-space> coc#refresh()

" use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <CR> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" function to show documentation in a preview window
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction


"" ------------------- lightline

" configure the status line
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

" configure the window when using fzf inside of vim (and only inside of vim)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,2"

