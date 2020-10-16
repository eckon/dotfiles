" ---------- Plugin Installations {{{1
call plug#begin()
  " Tools {{{2
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'lambdalisue/fern.vim'
  Plug 'mbbill/undotree'
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
  Plug 'preservim/nerdcommenter'
  Plug 'rhysd/clever-f.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'wellle/targets.vim'

  " Syntax/Styling/Appearance {{{2
  Plug 'Yggdroot/indentLine'
  Plug 'itchyny/lightline.vim'
  Plug 'lambdalisue/fern-git-status.vim'
  Plug 'lambdalisue/fern-renderer-nerdfont.vim'
  Plug 'lambdalisue/nerdfont.vim'
  Plug 'mhinz/vim-signify'
  Plug 'morhetz/gruvbox'
  Plug 'psliwka/vim-smoothie'

  " Special (compatibility/others) {{{2
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }
  Plug 'tmux-plugins/vim-tmux-focus-events'
  " }}}2
call plug#end()



" ---------- General Configuration {{{1
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
set shortmess+=c
set showcmd showmatch noshowmode
set signcolumn=yes
set splitbelow splitright
set timeoutlen=1500 updatetime=100
set title

" disable netrwhist
let g:netrw_dirhistmax = 0

" reload buffer when file changed from outside
set autoread
autocmd FocusGained,BufEnter * checktime

let mapleader = "\<Space>"



" ---------- Color/Style {{{1
colorscheme gruvbox
set cursorline colorcolumn=80,120,121
set list listchars=nbsp:¬,extends:»,precedes:«,trail:·,space:·,tab:▸\ 
set scrolloff=5



" ---------- General Key Bindings {{{1
" source current buffer
nnoremap <Leader><Leader>s :so %<CR>

" disable keys and/or set custom 'default' behaviour
nnoremap Q <Nop>
nnoremap <F1> <Nop>
inoremap <F1> <C-v><F1>

" quick safe for different vim modes
" use <CMD> so that we do not need to reselect in visual mode (gv)
map <C-s> <CMD>w<CR>
imap <C-s> <ESC><C-s>

" moving between and Resizing windows (eqiuvalent to <Ctrl-W>)
nmap <silent><Leader>wj :wincmd j<CR>
nmap <silent><Leader>wk :wincmd k<CR>
nmap <silent><Leader>wh :wincmd h<CR>
nmap <silent><Leader>wl :wincmd l<CR>
nmap <silent><Leader>wf :wincmd _ <Bar> :wincmd <Bar> <CR>
nmap <silent><Leader>we :wincmd =<CR>
nmap <silent><Leader>w- :wincmd s<CR>
nmap <silent><Leader>w<Bar> :wincmd v<CR>
nmap <silent><Leader>wc :wincmd c<CR>
nmap <silent><Leader>wo :wincmd o<CR>

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
nmap <Leader>tc :tabclose<CR>
nmap <Leader>tm :tabmove
nmap <Leader>tn :tabnew<CR>
nmap <Leader>to :tabonly<CR>
nmap <Leader>th gT
nmap <Leader>tl gt


" ---------- Plugin Configurations {{{1
" ----- clever-f {{{2
let g:clever_f_across_no_line = 1



" ----- coc {{{2
" -- Configurations {{{3
" set coc extensions that should always be installed
" essential
let g:coc_global_extensions = [
  \   'coc-emmet',
  \   'coc-yank',
  \   'coc-pairs',
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


" -- Mappings {{{3
autocmd CursorHold * silent call CocActionAsync('highlight')

" use K to show documentation in preview window
nnoremap <silent>K :call <SID>show_documentation()<CR>

" goto code navigation and other coc commands
nmap <silent>[g <Plug>(coc-diagnostic-prev)
nmap <silent>]g <Plug>(coc-diagnostic-next)
nmap <silent>gd <Plug>(coc-definition)
nmap <silent>gi <Plug>(coc-implementation)
nmap <silent>gr <Plug>(coc-references)
nmap <silent>gy <Plug>(coc-type-definition)
nmap <silent><Leader>ac <Plug>(coc-codeaction)
nmap <silent><Leader>rn <Plug>(coc-rename)
nmap <silent><Leader>f <Plug>(coc-format)
xmap <silent><Leader>f <Plug>(coc-format-selected)

" use <C-space> to trigger coc code completion
inoremap <silent><expr><C-space> coc#refresh()

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
function! s:show_documentation() abort
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction



" ----- fern {{{2
" -- Configurations {{{3
let g:fern#default_hidden = 1
let g:fern#renderer = 'nerdfont'
let g:fern#smart_cursor = 'hide'


" -- Mappings {{{3
nmap <silent><C-n> :Fern . -drawer -reveal=% -toggle<CR>
nmap <silent><C-j> :Fern %:h<CR>

function! FernInit() abort
  nmap <buffer>* <Plug>(fern-action-mark)
  nmap <buffer>- <Plug>(fern-action-open:split)
  nmap <buffer><Bar> <Plug>(fern-action-open:vsplit)
  nmap <buffer>D <Plug>(fern-action-remove)
  nmap <buffer>n <Plug>(fern-action-new-path)
  nmap <buffer>p <Plug>(fern-action-open:edit)<C-w><C-p>j
  nmap <buffer>P <Plug>(fern-action-open:edit)<C-w><C-p>k
  nmap <buffer>> <Plug>(fern-action-enter)
  nmap <buffer>< <Plug>(fern-action-leave)
endfunction

augroup FernGroup
  autocmd!
  autocmd FileType fern call FernInit()
augroup END



" ----- fugitive {{{2
" quick actions for git status in the same buffer
nmap <silent><Leader>gs :Gedit :<CR>
nmap <Leader>gd :Gdiffsplit<CR>

" quick actions for git merge conflicts left side 'f' (merge into) right 'j'
nmap <Leader>gf :diffget //2<CR>
nmap <Leader>gj :diffget //3<CR>



" ----- fzf {{{2
" -- Configurations {{{3
" configure the window when using fzf inside of vim (and only inside of vim)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
let $FZF_DEFAULT_OPTS = "--ansi --preview-window 'right:60%' --layout reverse --margin=1,2"
" enable to use ctrl-p/n in fzf window to cycle through history
let g:fzf_history_dir = '~/.local/share/fzf-history'


" -- Mappings {{{3
" Call ag and pass the hidden flag to also show dotfiles
" Taken from https://github.com/junegunn/fzf.vim/issues/92 and modified
command! -bang -nargs=* AgHidden
  \ call fzf#vim#ag(
  \   <q-args>,
  \   '--hidden --ignore ".git"',
  \   <bang>0
  \ )

" enable usage of ctrl-r (e.g. to paste vim buffer) in fzf windows
" for the current default buffer press ctrl- + "
tnoremap <expr><C-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'"'

" find files, lines, content, mappings, commits in project and open buffers
nnoremap <C-_> :AgHidden<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <C-f> :BLines<CR>
nnoremap <C-h> :BCommits<CR>
nnoremap <C-p> :GFiles<CR>



" ----- indentline {{{2
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_fileTypeExclude = [
  \   'fern',
  \   'fugitive',
  \   'git',
  \   'help',
  \   'json',
  \ ]



" ----- lightline {{{2
" configure the status line
let g:lightline = {
  \   'colorscheme': 'powerline',
  \   'active': {
  \     'left': [ [ 'mode', 'paste' ],
  \               [ 'gitbranch' ],
  \               [ 'readonly', 'filename', 'modified' ] ],
  \     'right': [ [ 'lineinfo' ],
  \                [ 'percent' ],
  \                [ 'cocstatus', 'filetype', 'fileencoding', 'fileformat' ] ]
  \   },
  \   'component_function': {
  \     'gitbranch': 'FugitiveHead',
  \     'cocstatus': 'coc#status',
  \   },
  \ }



" ----- nerdcommenter {{{2
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1


nmap <Leader>c<Space> <plug>NERDCommenterToggle
xmap <Leader>c<Space> <plug>NERDCommenterToggle



" ----- undotree {{{2
let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1


nmap <silent><Leader>u :UndotreeToggle<CR>
