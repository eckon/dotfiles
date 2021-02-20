" vim:foldmethod=marker

" -------------------- Plugin Installations {{{1
call plug#begin()
  " Tools {{{2
  Plug 'jiangmiao/auto-pairs'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
  Plug 'rhysd/git-messenger.vim'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'vimwiki/vimwiki'

  " Syntax/Styling/Appearance {{{2
  Plug 'gruvbox-community/gruvbox'
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'mhinz/vim-signify'
  Plug 'norcalli/nvim-colorizer.lua'
  Plug 'psliwka/vim-smoothie'
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
set mouse=a
set nobackup nowritebackup noswapfile undofile
set noerrorbells
set nowrap
set number relativenumber
set shiftwidth=2 tabstop=2 softtabstop=2 smarttab autoindent smartindent expandtab
set shortmess+=c
set showcmd showmatch showmode
set signcolumn=yes
set splitbelow splitright
set timeoutlen=1500 updatetime=100
set title

" reload buffer when file changed from outside
set autoread
autocmd FocusGained,BufEnter * checktime



" -------------------- Color/Style Configuration {{{1
if has('termguicolors')
  set termguicolors
endif

colorscheme gruvbox
set background=dark
set cursorline colorcolumn=80,120,121
set list listchars=nbsp:¬,extends:»,precedes:«,trail:·,space:·,tab:▸\ 
set scrolloff=5

" ---------- custom status line {{{2
" initialisation of the status line
set statusline=
" mode
set statusline+=%4*%8(%{GetCurrentMode()}%)\ 
set statusline+=%-5((%{mode(1)})%)
" git head
set statusline+=%1*\ %{GetGitBranchName()}\ 
" readonly / filename / modified
set statusline+=%2*\ %t%m%r
" end of line
set statusline+=%=
" coc status / filetype / filencoding / fileformat
set statusline+=%3*%{coc#status()}\ %{&filetype}\ %{&fenc?&fenc:&enc}\ %{&ff}\ 
" percantage of file / line number / column number
set statusline+=%1*\ %4(%p%%%)\ \|\ %-6(%l:%c%)\ 

" highlight colors mainly for status line colors/styling
" gruvbox color palette
let colors = {
  \   'black': '#282828',
  \   'white': '#ebdbb2',
  \   'red': '#fb4934',
  \   'green': '#b8bb26',
  \   'blue': '#83a598',
  \   'yellow': '#fe8019',
  \   'gray': '#a89984',
  \   'darkgray': '#3c3836',
  \   'lightgray': '#504945',
  \   'inactivegray': '#7c6f64',
  \ }

highlight User1 cterm=NONE ctermfg=white  ctermbg=darkgray
execute 'highlight User1 gui=NONE guifg=' . g:colors.white . ' guibg=' . g:colors.lightgray
highlight User2 cterm=NONE ctermfg=yellow ctermbg=black
execute 'highlight User2 gui=NONE guifg=' . g:colors.gray . ' guibg=' . g:colors.darkgray
highlight User3 cterm=NONE ctermfg=grey   ctermbg=black
execute 'highlight User3 gui=NONE guifg=' . g:colors.gray . ' guibg=' . g:colors.darkgray
highlight User4 cterm=bold ctermfg=black ctermbg=darkblue
execute 'highlight User4 gui=bold guifg=' . g:colors.black . ' guibg=' . g:colors.blue

" helper functions for status line
function! GetCurrentMode() abort
  " table for different modes
  let modeTranslation={
    \   'n': 'NORMAL',
    \   'v': 'VISUAL',
    \   'V': 'V-Line',
    \   "\<C-v>": 'V-Block',
    \   'i': 'INSERT',
    \   'R': 'REPLACE',
    \   'c': 'COMMAND',
    \   't': 'TERM',
    \ }

  let mode = mode()
  " use get instead of [] to have a default value if we run into other modes
  return get(modeTranslation, mode, 'NOT-SET')
endfunction

" helper functions to get git branch name but only set it when needed
augroup GitBranchName
  autocmd!
  autocmd BufEnter,FocusGained,FocusLost * call SetGitBranchName()
augroup END

function! SetGitBranchName() abort
  let g:git_branch_name = trim(system('git branch --show-current'))
endfunction

function! GetGitBranchName() abort
  return get(g:, 'git_branch_name', '')
endfunction

" highlight yanked text with lua
augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END



" -------------------- General Key Bindings / Commands / Abbreviations {{{1
" ---------- Custom Key Bindings {{{2
" disable keys and/or set custom 'default' behaviour
nnoremap Q <Nop>
nnoremap <F1> <Nop>
inoremap <F1> <C-v><F1>

" quick safe for different vim modes
" use <CMD> so that we do not need to reselect in visual mode (gv)
noremap <C-s> <CMD>w<CR>
imap <C-s> <ESC><C-s>

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

" easy way of hiding highlight
nnoremap <ESC><ESC> <ESC><CMD>nohlsearch<CR>


" ---------- Custom Commands {{{2
" open current buffer file in the browser (needs to be cloned over git with ssh)
command! OpenProjectInBrowser
  \ !xdg-open
  \ $(echo
  \   ${${${$(git config --get remote.origin.url)//.git/}//:/\/}//git@/https:\/\/}/blob/master/%
  \ )

" open current project and goto the current buffer file in vscode
command! OpenInVsCode !code $(pwd) -g %

" upload current buffer to bighost-dev server
"" this needs a 'swarmX-bighost-dev' in the .ssh/config to work
command! UploadBighost !scp %:p swarmX-bighost-dev:/%



" ---------- Custom Abbreviations {{{2
" add a shebang with the given filetype
inoreabbrev <expr> #!! "#!/usr/bin/env" . (empty(&filetype) ? '' : ' '.&filetype)



" -------------------- Plugin Configurations {{{1
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
  \   'coc-docker',
  \   'coc-html',
  \   'coc-json',
  \   'coc-vimlsp',
  \   'coc-yaml',
  \ ]
" specific
let g:coc_global_extensions += [
  \   'coc-angular',
  \   'coc-css',
  \   'coc-eslint',
  \   'coc-go',
  \   'coc-java',
  \   'coc-phpls',
  \   'coc-prettier',
  \   'coc-python',
  \   'coc-rust-analyzer',
  \   'coc-toml',
  \   'coc-tsserver',
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
inoremap <silent><expr> <C-space> coc#refresh()

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
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction



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

" find files, lines, content, buffers in project
nnoremap <Leader>fa <CMD>AgHidden<CR>
nnoremap <Leader>fb <CMD>Buffers<CR>
nnoremap <Leader>ff <CMD>GFiles<CR>
nnoremap <Leader>fl <CMD>BLines<CR>



" ---------- git-messenger {{{2
" ----- Configurations {{{3
let g:git_messenger_always_into_popup = v:true
let g:git_messenger_date_format = '%d.%m.%Y - %H:%M'
let g:git_messenger_no_default_mappings = v:true


" ----- Mappings {{{3
nmap <Leader>gb <Plug>(git-messenger)



" ---------- nvim-colorizer {{{2
" attach colorizer to file types
lua require'colorizer'.setup()



" ---------- nvim-tree {{{2
" ----- Configurations {{{3
let g:nvim_tree_disable_netrw = 0
let g:nvim_tree_hijack_netrw = 0
let g:nvim_tree_ignore = [ '.git', 'node_modules' ]
let g:nvim_tree_indent_markers = 1
let g:nvim_tree_quit_on_open = 1
let g:nvim_tree_root_folder_modifier = ':t:r'


" ----- Mappings {{{3
nnoremap <silent><Leader>, <CMD>NvimTreeToggle<CR>
nnoremap <silent><Leader>. <CMD>NvimTreeFindFile<CR>



" ---------- vimwiki {{{2
" set default path to $XDG_DATA_HOME/vimwiki
let g:vimwiki_list = [{
  \   'path': '~/.local/share/vimwiki',
  \   'syntax': 'markdown',
  \   'ext': '.md'
  \ }]
