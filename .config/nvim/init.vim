" -------------------- Plugin Installations {{{1
call plug#begin()
  " Tools {{{2
  Plug 'glepnir/lspsaga.nvim'
  Plug 'hrsh7th/nvim-compe'
  Plug 'neovim/nvim-lspconfig'
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
" ---------- LSP (lspconfig, lspsaga, nvim-compe) {{{2
" ----- Configurations {{{3
lua <<EOF

-- only setup angular-lsp when we are in a angular repo (seems like the server itself does not do that)
local is_angular_project = vim.call("filereadable", "angular.json") == 1
if is_angular_project then
  -- get the current global node_modules folder for the language-server
  -- otherwise it will check in the repo, which most likely does not have it
  local global_node_module_path = vim.call("system", "readlink -m $(which ngserver)/../../../..")
  local cmd = { "ngserver", "--stdio", "--tsProbeLocations", global_node_module_path , "--ngProbeLocations", global_node_module_path }
  require'lspconfig'.angularls.setup{
    cmd = cmd,
    on_new_config = function(new_config, new_root_dir)
      new_config.cmd = cmd
    end,
  }
end

require'lspconfig'.html.setup{}
require'lspconfig'.intelephense.setup{}
require'lspconfig'.jsonls.setup{}
require'lspconfig'.tsserver.setup{}
require'lspconfig'.vimls.setup{}
require'lspconfig'.vuels.setup{}
require'lspconfig'.yamlls.setup{}
EOF

lua <<EOF
require'lspsaga'.init_lsp_saga {
  max_preview_lines = 200,
  finder_action_keys = { open = '<CR>', vsplit = 'v', split = 'x', quit = { 'q', '<ESC>' } },
  code_action_keys = { quit = { 'q', '<ESC>' }, exec = '<CR>' },
  rename_action_keys = { quit = {'<C-c>', '<ESC>' }, exec = '<CR>' },
  border_style = 2,
}
EOF

lua << EOF
require'compe'.setup {
  source = {
    nvim_lsp = true,
    buffer = true,
    path = true,
    spell = true,
  },
}
EOF


" ----- Mappings {{{3
nnoremap <silent>K :call <SID>show_documentation()<CR>
nnoremap <C-k> <CMD>lua vim.lsp.buf.signature_help()<CR>
inoremap <C-k> <CMD>lua vim.lsp.buf.signature_help()<CR>
nnoremap gd <CMD>lua vim.lsp.buf.definition()<CR>
nnoremap gD <CMD>lua vim.lsp.buf.declaration()<CR>
nnoremap gr <CMD>lua vim.lsp.buf.references()<CR>
nnoremap [g <CMD>Lspsaga diagnostic_jump_prev<CR>
nnoremap ]g <CMD>Lspsaga diagnostic_jump_next<CR>

nnoremap <Leader>la <CMD>Lspsaga code_action<CR>
nnoremap <Leader>lr <CMD>Lspsaga rename<CR>
nnoremap <Leader>lf <CMD>lua vim.lsp.buf.formatting()<CR>
vnoremap <silent><Leader>lf :lua vim.lsp.buf.range_formatting()<CR>
nnoremap <Leader>ll <CMD>Lspsaga lsp_finder<CR>

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR> compe#confirm('<CR>')
inoremap <silent><expr> <C-c> compe#close('<C-c>')

" make normal completion to tabcompletion when popup-menu visible
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" use default K if we have something in help
function! s:show_documentation() abort
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h ' . expand('<cword>')
  else
    execute 'Lspsaga hover_doc'
  endif
endfunction



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
