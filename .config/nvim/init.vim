" -------------------- Plugin Installations {{{1
call plug#begin()
  " Tools {{{2
  Plug 'jiangmiao/auto-pairs'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'lambdalisue/fern.vim'
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
  Plug 'preservim/nerdcommenter'
  Plug 'rhysd/clever-f.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'vimwiki/vimwiki'

  " Syntax/Styling/Appearance {{{2
  Plug 'chrisbra/Colorizer'
  Plug 'itchyny/lightline.vim'
  Plug 'lambdalisue/fern-git-status.vim'
  Plug 'lambdalisue/fern-renderer-nerdfont.vim'
  Plug 'lambdalisue/nerdfont.vim'
  Plug 'mhinz/vim-signify'
  Plug 'morhetz/gruvbox'
  Plug 'psliwka/vim-smoothie'

  " Special (compatibility/others) {{{2
  Plug 'tmux-plugins/vim-tmux-focus-events'
  " }}}2
call plug#end()



" -------------------- General Configuration {{{1
let mapleader = "\<Space>"

syntax enable
filetype plugin on

set backspace=eol,start,indent
set clipboard+=unnamedplus
set foldmethod=indent nofoldenable
set hidden
set hlsearch ignorecase incsearch magic smartcase
set inccommand=nosplit
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



" -------------------- Color/Style Configuration {{{1
colorscheme gruvbox
set background=dark
set cursorline colorcolumn=80,120,121
set list listchars=nbsp:¬,extends:»,precedes:«,trail:·,space:·,tab:▸\ 
set scrolloff=5

" custom status line
set statusline=%#DiffAdd#
"" mode (use get, for the default case if its not in the dictionary)
set statusline+=\ %{toupper(get(g:currentmode,mode(),'NOT-SET'))}\ 
"" git head
set statusline+=%#PmenuSel#\ %{FugitiveHead()}\ 
"" readonly / filename / modified
set statusline+=%#Normal#\ %r%t%m
"" end of line
set statusline+=%=
"" coc status / filetype / filencoding / fileformat
set statusline+=%#LineNr#%{coc#status()}\ %{&filetype}\ %{&fenc?&fenc:&enc}\ %{&ff}\ 
" percantage of file / line number / column number
set statusline+=%#Line#\ %p%%\ %l:%c\ 

"" table for different modes
let g:currentmode={
       \ 'n'  : 'NORMAL',
       \ 'v'  : 'VISUAL',
       \ 'V'  : 'V·Line',
       \ '' : 'V·Block',
       \ 'i'  : 'INSERT',
       \ 'R'  : 'Replace',
       \ 'Rv' : 'V·Replace',
       \ 'c'  : 'Command',
       \}

" custom transparency setting (mainly signify and background)
let enableTransparency = 1

if enableTransparency
  " set background to be non visible (transparent)
  highlight Normal guibg=NONE ctermbg=NONE
  highlight SignColumn guibg=NONE ctermbg=NONE
endif

" highlight yanked text with lua
augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END



" -------------------- General Key Bindings {{{1
" source current buffer
nnoremap <Leader><Leader>s :so %<CR>

" disable keys and/or set custom 'default' behaviour
nnoremap Q <Nop>
nnoremap <F1> <Nop>
inoremap <F1> <C-v><F1>

" quick safe for different vim modes
" use <CMD> so that we do not need to reselect in visual mode (gv)
noremap <C-s> <CMD>w<CR>
imap <C-s> <ESC><C-s>

" Y should behave like other uppercase commands (until end of line)
nnoremap Y y$

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



" -------------------- Plugin Configurations {{{1
" ---------- clever-f {{{2
let g:clever_f_across_no_line = 1



" ---------- coc {{{2
" ----- Configurations {{{3
" set coc extensions that should always be installed
" essential
let g:coc_global_extensions = [
  \   'coc-emmet',
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


" ----- Mappings {{{3
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
nmap <silent><Leader>cac <Plug>(coc-codeaction)
nmap <silent><Leader>crn <Plug>(coc-rename)
nmap <silent><Leader>cf <Plug>(coc-format)
xmap <silent><Leader>cf <Plug>(coc-format-selected)

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



" ---------- fern {{{2
" ----- Configurations {{{3
let g:fern#default_hidden = 1
let g:fern#renderer = 'nerdfont'
let g:fern#smart_cursor = 'hide'


" ----- Mappings {{{3
nnoremap <silent><Leader>, <CMD>Fern . -drawer -reveal=% -toggle<CR>
nnoremap <silent><Leader>. <CMD>Fern %:h<CR>

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



" ---------- fugitive {{{2
" quick actions for git status in the same buffer
nnoremap <silent><Leader>gs :Gedit :<CR>

" quick actions for git merge conflicts left side 'f' (merge into) right 'j'
nnoremap <Leader>gf :diffget //2<CR>
nnoremap <Leader>gj :diffget //3<CR>

" other quick actions
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gd :Gdiff<Space>
nnoremap <Leader>gf :Gfetch<Space>
nnoremap <Leader>gl :Gpull<Space>
nnoremap <Leader>gm :Gmerge<Space>
nnoremap <Leader>gp :Gpush<Space>



" ---------- fzf {{{2
" ----- Configurations {{{3
" configure the window when using fzf inside of vim (and only inside of vim)
let $FZF_DEFAULT_OPTS = "--layout reverse --margin=1,2"
let g:fzf_layout = { 'window': { 'width': 0.98, 'height': 0.98 } }
" enable to use ctrl-p/n in fzf window to cycle through history
let g:fzf_history_dir = '~/.local/share/fzf-history'


" ----- Mappings {{{3
" call ag and pass the hidden flag to also show dotfiles
" taken from https://github.com/junegunn/fzf.vim/issues/92 and modified
command! -bang -nargs=* AgHidden
  \ call fzf#vim#ag(
  \   <q-args>,
  \   '--hidden --ignore ".git"',
  \   <bang>0
  \ )

" enable usage of ctrl-r (e.g. to paste vim buffer) in fzf windows
" for the current default buffer press ctrl-"
tnoremap <expr><C-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'"'

" quick way to see all available maps in the current mode
nmap <Leader><Tab> <Plug>(fzf-maps-n)
xmap <Leader><Tab> <Plug>(fzf-maps-x)
omap <Leader><Tab> <Plug>(fzf-maps-o)

" find files, lines, content, mappings, commits in project and open buffers
nnoremap <Leader>fa <CMD>AgHidden<CR>
nnoremap <Leader>fb <CMD>Buffers<CR>
nnoremap <Leader>fc <CMD>BCommits<CR>
nnoremap <Leader>ff <CMD>GFiles<CR>
nnoremap <Leader>fh <CMD>History<CR>
nnoremap <Leader>fl <CMD>BLines<CR>
nnoremap <Leader>fm <CMD>Marks<CR>
nnoremap <Leader>fs <CMD>Snippets<CR>



" ---------- lightline {{{2
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



" ---------- nerdcommenter {{{2
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1


nmap <Leader>c<Space> <Plug>NERDCommenterToggle
xmap <Leader>c<Space> <Plug>NERDCommenterToggle



" ---------- signify {{{2
if enableTransparency
  " set background of sign column to be non visible (transparency)
  highlight SignifySignAdd guibg=NONE ctermbg=NONE ctermfg=green
  highlight SignifySignChange guibg=NONE ctermbg=NONE ctermfg=red
  highlight SignifySignDelete guibg=NONE ctermbg=NONE ctermfg=yellow
endif



" ---------- vimwiki {{{2
" set default path to $XDG_DATA_HOME/vimwiki
let g:vimwiki_list = [{ 'path': '~/.local/share/vimwiki' }]

" overwrite default behaviour of using markdown as vimwiki
let g:vimwiki_ext2syntax = {}
let g:vimwiki_global_ext = 0
