"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Plugins (call :PlugInstall in nvim/vim to install)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin()

" theme
Plug 'joshdick/onedark.vim'
" language server and other vscode quality of life
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" basic fzf (needed fof fzf.vim
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" fzf integrated into vim -> open with :Files other files
Plug 'junegunn/fzf.vim'
" get colored brackets
Plug 'luochen1990/rainbow'
" highlight the area that was yanked/copied
Plug 'machakann/vim-highlightedyank'
" show lines that were deleted/updated/added in the editor
Plug 'airblade/vim-gitgutter'
" comment blocks of code
Plug 'preservim/nerdcommenter'
" automatically close opened brackets etc.
Plug 'jiangmiao/auto-pairs'
" add commands to add/edit/delete surrounding things like "" or '' or ()
Plug 'tpope/vim-surround'
" add mutlicursor
Plug 'terryma/vim-multiple-cursors'
" add styling of nvim/vim statusline
Plug 'itchyny/lightline.vim'

call plug#end()


""""""""""""""""""""
""" Configurations
""""""""""""""""""""

"""""""""""""""
"" nvim / vim
let mapleader = " "

" Styling
syntax on
color onedark

" Set lines to be relative with the absolute number on the current line
set number relativenumber

" Set 15 lines to the cursor - when moving vertically using j/k
" If you want to center all the time use so=999 or use zz to center once
set so=15

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" Highlight current line
set cursorline

" Highlight "maximum" column for readable code
set colorcolumn=120

" Show hidden characters
set listchars=nbsp:¬,extends:»,precedes:«,tab:▸\ ,trail:·
set list

" Show the current mode
set showmode

" Show the filename in the window titlebar
set title

" Show the (partial) command as it’s being typed
set showcmd

" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" set to use the same buffer for clipboard
set clipboard+=unnamedplus

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Quickly insert an empty new line without entering insert mode
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

" Quickly search for a file with fzf (:Files) in the nvim window
nnoremap <Leader>f :Files<CR>


"""""""""""""
"" coc.nvim

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

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

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> g[ <Plug>(coc-diagnostic-prev)
nmap <silent> g] <Plug>(coc-diagnostic-next)

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')


"""""""""""
" rainbow

let g:rainbow_active = 1


""""""""""""""""""
" nerd commenter

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1


""""""""""""""
" lightline

" lightline gives a status bar -> remove the standard one
set noshowmode


""""""""""
" fzf

" search project to open file (dependend on git)
nnoremap <C-p> :GFiles<CR>


