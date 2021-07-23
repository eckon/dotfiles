" -------------------- Plugin Installations {{{1
call plug#begin()
  " Tools {{{2
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
  Plug 'preservim/nerdtree'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'hoob3rt/lualine.nvim'
  Plug 'phaazon/hop.nvim'

  " Syntax/Styling/Appearance/Special {{{2
  Plug 'gruvbox-community/gruvbox'
  Plug 'mhinz/vim-signify'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'tmux-plugins/vim-tmux-focus-events'
  " }}}2
call plug#end()



" -------------------- General Configuration {{{1
let mapleader = "\<Space>"

syntax enable
filetype plugin on

set autoread
set backspace=eol,start,indent
set clipboard+=unnamedplus
set completeopt=menuone,noinsert,noselect
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
set shell=bash
set shiftwidth=2 tabstop=2 softtabstop=2 smarttab autoindent smartindent expandtab
set shortmess+=c
set showcmd showmatch showmode
set signcolumn=yes
set splitbelow splitright
set timeoutlen=1000 updatetime=100
set title
set wildmode=list:longest,list:full

" enable embedded script highlighting of lua code
let g:vimsyn_embed = 'l'



" -------------------- Color/Style Configuration {{{1
if has('termguicolors')
  set termguicolors
endif

colorscheme gruvbox
set background=dark
set cursorline colorcolumn=80,120,121
set list listchars=nbsp:¬,extends:»,precedes:«,lead:\ ,trail:·,space:·,tab:▸\ 
set scrolloff=5

augroup HighlightYankedText
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END



" -------------------- General Key Bindings / Commands / Abbreviations {{{1
" ---------- Custom Key Bindings {{{2
" disable annoying keys
nnoremap Q <Nop>
nnoremap <F1> <Nop>
inoremap <F1> <Nop>

" rehighlight text after indenting
vnoremap < <gv
vnoremap > >gv

" extend redraw of screen with hiding the highlight of search results
nnoremap <C-l> <CMD>nohlsearch<CR><C-l>



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

" fill quickfix with errors, do some formatting to have correct quickfix format
" path:line:col:message
command! RunEslint cexpr system("npx eslint -f unix '{src,apps}/**/*.ts' | awk 'length($0) > 20 {print $0}'")
command! RunTsc    cexpr system("npx tsc | sed 's/[(,]/:/g' | sed 's/)//'")



" -------------------- Plugin Configurations {{{1
" ---------- coc {{{2
" ----- Configurations {{{3
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
  \   'coc-angular',
  \   'coc-clangd',
  \   'coc-cmake',
  \   'coc-css',
  \   'coc-emmet',
  \   'coc-eslint',
  \   'coc-fish',
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

nnoremap <silent>K :call <SID>show_documentation()<CR>
inoremap <silent><expr> <C-space> coc#refresh()

nmap <silent>[g <Plug>(coc-diagnostic-prev)
nmap <silent>]g <Plug>(coc-diagnostic-next)
nmap <silent>gd <Plug>(coc-definition)
nmap <silent>gD <Plug>(coc-declaration)
nmap <silent>gr <Plug>(coc-references)
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




" ---------- Hop {{{2
" ----- Configurations {{{3
lua << EOF
require'hop'.setup()
EOF


" ----- Mappings {{{3
nnoremap S <CMD> HopWord<CR>



" ---------- lualine {{{2
" ----- Configurations {{{3
lua << EOF
require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = 'gruvbox',
    component_separators = {},
    section_separators = {},
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename', 'diff'}, 
    lualine_x = {'g:coc_status', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  }
})
EOF



" ---------- NERDTree {{{2
" ----- Configurations {{{3
let NERDTreeShowHidden = 1
let NERDTreeQuitOnOpen = 1


" ----- Mappings {{{3
nnoremap <Leader>. <CMD>NERDTreeFind<CR>
nnoremap <Leader>, <CMD>NERDTree<CR>



" ---------- nvim-treesitter {{{2
" ----- Configurations {{{3
lua << EOF
require('nvim-treesitter.configs').setup {
  -- following languages are not used, because they are worse then the regex one
  -- php, yaml
  ensure_installed = {
    'typescript', 'javascript', 'vue',
    'json', 'html', 'css',
    'bash', 'fish', 'python',
    'rust', 'c', 'cpp',
  },
  highlight = { enable = true },
}
EOF



" ---------- Fuzzy-Search (fzf.vim) {{{2
" ----- Configurations {{{3
" enable to use ctrl-p/n in fzf window to cycle through history
let g:fzf_history_dir = '~/.local/share/fzf-history'


" ----- Mappings {{{3
nnoremap <Leader><TAB> <CMD>Commands<CR>
" show all files of <range> parents folders from current file
nnoremap <Leader>f. <CMD>call fzf#vim#files(expand("%:p" . repeat(":h", v:count1)))<CR>
nnoremap <Leader>fa :Ag 
nnoremap <Leader>fb <CMD>Buffers<CR>
nnoremap <Leader>ff <CMD>GFiles<CR>
nnoremap <Leader>fg <CMD>GFiles?<CR>
nnoremap <Leader>fl <CMD>BLines<CR>

" vim:foldmethod=marker
