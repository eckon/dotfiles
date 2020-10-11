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
  Plug 'rhysd/clever-f.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'wellle/targets.vim'
  " Syntax/Styling/Appearance
  Plug 'Yggdroot/indentLine'
  Plug 'airblade/vim-gitgutter'
  Plug 'itchyny/lightline.vim'
  Plug 'morhetz/gruvbox'
  Plug 'psliwka/vim-smoothie'
  " Special (compatibility/others)
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }
  Plug 'tmux-plugins/vim-tmux-focus-events'
call plug#end()



" -------------------- General Setting --------------------
"  filetype specific settings can be found in the ftplugin folder
"  plugin specific settings can be found in the plugin folder

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
set timeoutlen=1500 updatetime=100
set title

" reload buffer when file changed from outside
set autoread
autocmd FocusGained,BufEnter * checktime

" disable netrw
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

let mapleader = "\<Space>"


" -------------------- Color/Style Settings --------------------

colorscheme gruvbox
set background=dark
set cursorline colorcolumn=80,120,121
set list listchars=nbsp:¬,extends:»,precedes:«,trail:·,space:·,tab:▸\ 
set scrolloff=5



" -------------------- Key Bindings --------------------
" plugin specific mappings can be found in the plugin folder

" source current buffer
nnoremap <Leader><Leader>s :so %<CR>

" hide search highlighting
nnoremap <Leader><Leader>/ :noh<CR>

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

