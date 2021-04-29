" -------------------- Plugin Installations {{{1
call plug#begin()
  " Tools {{{2
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-telescope/telescope-fzy-native.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'preservim/nerdtree'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'

  " Syntax/Styling/Appearance {{{2
  Plug 'gruvbox-community/gruvbox'
  Plug 'mhinz/vim-signify'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'psliwka/vim-smoothie'
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
set shiftwidth=2 tabstop=2 softtabstop=2 smarttab autoindent smartindent expandtab
set shortmess+=c
set showcmd showmatch showmode
set signcolumn=yes
set splitbelow splitright
set timeoutlen=1000 updatetime=100
set title

" enable embedded script highlighting of lua code
let g:vimsyn_embed = 'l'

" configure vim-markdown from tpope (installed by vim itself)
let g:markdown_fenced_languages = [
  \ 'javascript', 'json=javascript', 'js=javascript',
  \ 'typescript', 'ts=typescript',
  \ 'sh', 'bash=sh',
  \ 'php',
  \ 'python',
  \ ]



" -------------------- Color/Style Configuration {{{1
if has('termguicolors')
  set termguicolors
endif

colorscheme gruvbox
set background=dark
set cursorline colorcolumn=80,120,121
set list listchars=nbsp:¬,extends:»,precedes:«,trail:·,space:·,tab:▸\ 
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



" -------------------- Plugin Configurations {{{1
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
    'bash', 'python',
  },
  highlight = { enable = true },
}
EOF



" ---------- telescope (& fzy) {{{2
" ----- Configurations {{{3
lua << EOF
local actions = require('telescope.actions')

require('telescope').setup {
  defaults = {
    mappings = { i = { ["<ESC>"] = actions.close } },
  },
}

require('telescope').load_extension('fzy_native')
EOF


" ----- Mappings {{{3
nnoremap <Leader><Tab> <CMD>lua require('telescope.builtin').builtin()<CR>
nnoremap <Leader>f, <CMD>lua require('telescope.builtin').file_browser()<CR>
nnoremap <Leader>f. <CMD>lua require('telescope.builtin').file_browser({ cwd = vim.fn.expand("%:p:h") })<CR>
nnoremap <Leader>ff <CMD>lua require('telescope.builtin').git_files()<CR>
nnoremap <Leader>fh <CMD>lua require('telescope.builtin').git_files({ layout_config = { preview_width = 0 } })<CR>
nnoremap <Leader>fb <CMD>lua require('telescope.builtin').buffers({ sort_lastused = true })<CR>
nnoremap <Leader>fg <CMD>lua require('telescope.builtin').git_status()<CR>
nnoremap <Leader>fa <CMD>lua require('telescope.builtin').live_grep()<CR>
nnoremap <Leader>fl <CMD>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>

" vim:foldmethod=marker
