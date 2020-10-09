" -------------------- Plugins --------------------
call plug#begin()
  " Tools
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'lambdalisue/fern-hijack.vim'
  Plug 'lambdalisue/fern-renderer-nerdfont.vim'
  Plug 'lambdalisue/fern.vim'
  Plug 'lambdalisue/nerdfont.vim'
  Plug 'mbbill/undotree'
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
  Plug 'preservim/nerdcommenter'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'
  " Syntax/Styling/Appearance
  Plug 'airblade/vim-gitgutter'
  Plug 'itchyny/lightline.vim'
  Plug 'morhetz/gruvbox'
  Plug 'psliwka/vim-smoothie'
  Plug 'ryanoasis/vim-devicons'
  " Special (compatibility/others)
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }
  Plug 'tmux-plugins/vim-tmux-focus-events'
call plug#end()



" -------------------- General Setting --------------------
syntax enable
filetype plugin on

set backspace=eol,start,indent
set clipboard+=unnamedplus
set hidden
set hlsearch ignorecase incsearch magic smartcase
set lazyredraw
set nobackup nowritebackup noswapfile undofile
set noerrorbells
set nowrap
set number relativenumber
set shiftwidth=2 tabstop=2 softtabstop=2 smarttab autoindent smartindent expandtab
set showcmd showmatch noshowmode
set signcolumn=yes
set splitbelow splitright
set timeoutlen=1500 updatetime=250
set title

" special
let g:NERDSpaceDelims=1
let g:NERDDefaultAlign='left'
let g:NERDCommentEmptyLines=1
" disable netrw
let g:loaded_netrw=1
let g:loaded_netrwPlugin=1
" will be handled by coc-ultisnips extension
" use random key because empty will result in mapping errors
let g:UltiSnipsExpandTrigger='<Nop>'

" reload buffer when file changed from outside
set autoread
autocmd FocusGained,BufEnter * checktime



" -------------------- Color/Style Settings --------------------
colorscheme gruvbox
set background=dark
set cursorline colorcolumn=80,120,121
set list listchars=nbsp:¬,extends:»,precedes:«,trail:·,space:·,tab:▸\ 
set scrolloff=5

autocmd CursorHold * silent call CocActionAsync('highlight')



" -------------------- Key Bindings --------------------
let mapleader = "\<Space>"

" disable keys and/or set custom 'default' behaviour
nnoremap Q <Nop>
nnoremap <F1> <Nop>
inoremap <F1> <C-v><F1>

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

" paste content without new line (example: dd into paste of parameter)
nnoremap gP i<CR><ESC>PkgJgJ
nnoremap gp a<CR><ESC>PkgJgJ

" navigating and Managing tabs
map <Leader>tc :tabclose<CR>
map <Leader>tm :tabmove
map <Leader>tn :tabnew<CR>
map <Leader>to :tabonly<CR>
map <Leader>th gT
map <Leader>tl gt

" find files, lines, content in project and open buffers
nnoremap <C-_> :Ag<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <C-f> :BLines<CR>
nnoremap <C-h> :BCommits<CR>
nnoremap <C-p> :GFiles<CR>

" quick actions for git status in the same buffer
nmap <silent> <Leader>gs :Gedit :<CR>
nmap <Leader>gd :Gdiffsplit<CR>

" quick actions for git merge conflicts left side 'f' (merge into) right 'j'
nmap <Leader>gf :diffget //2<CR>
nmap <Leader>gj :diffget //3<CR>

" goto code navigation and other coc commands
nmap <Leader>ac <Plug>(coc-codeaction)
nmap <Leader>qf <Plug>(coc-fix-current)
nmap <Leader>rn <Plug>(coc-rename)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> <Leader>f <Plug>(coc-format)
xmap <silent> <Leader>f <Plug>(coc-format-selected)

" use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" use <C-space> to trigger coc code completion
inoremap <silent><expr> <C-space> coc#refresh()

" toggle undotree and focus when it is open
map <silent> <Leader>u :UndotreeToggle \| UndotreeFocus<CR>



" -------------------- Plugin Specific Settings --------------------

"" ------------------- fern.vim
map <silent><C-n> :Fern . -drawer -reveal=% -toggle<Cr>

" todo: make when tree visible, toggle reatache to the tree instead of close
let g:fern#renderer = "nerdfont"
let g:fern#default_hidden=1
let g:fern#disable_default_mappings=1

"" ------------------- coc.nvim

" set coc extensions that should always be installed
" essential
let g:coc_global_extensions = [
  \   'coc-emmet',
  \   'coc-yank',
  \   'coc-pairs',
  \   'coc-ultisnips',
  \   'coc-marketplace',
  \ ]
" general
let g:coc_global_extensions += [
  \   'coc-json',
  \   'coc-vimlsp',
  \   'coc-html',
  \   'coc-yaml',
  \   'coc-docker',
  \ ]
" specific
let g:coc_global_extensions += [
  \   'coc-tsserver',
  \   'coc-css',
  \   'coc-prettier',
  \   'coc-eslint',
  \   'coc-phpls',
  \   'coc-angular',
  \   'coc-go',
  \   'coc-python',
  \   'coc-java',
  \   'coc-rust-analyzer',
  \ ]

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

" enable usage of ctrl-r (e.g. to paste vim buffer) in fzf windows
tnoremap <expr> <C-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'"'
