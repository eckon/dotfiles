" vim:foldmethod=marker

" -------------------- Plugin Installations {{{1
call plug#begin()
  " Tools {{{2
  Plug 'glepnir/lspsaga.nvim'
  Plug 'hrsh7th/nvim-compe'
  Plug 'jiangmiao/auto-pairs'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'rhysd/git-messenger.vim'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'

  " Syntax/Styling/Appearance {{{2
  Plug 'gruvbox-community/gruvbox'
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'mhinz/vim-signify'
  Plug 'norcalli/nvim-colorizer.lua'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'psliwka/vim-smoothie'
  " }}}2
call plug#end()



" -------------------- General Configuration {{{1
let mapleader = "\<Space>"

syntax enable
filetype plugin on

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
set timeoutlen=1500 updatetime=100
set title

" reload buffer when file changed from outside
set autoread
autocmd FocusGained,BufEnter * checktime

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
nnoremap gh <CMD>nohlsearch<CR>


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

" own small vimwiki styled note taking file
command! OpenNotes edit ~/.local/share/notes/index.md


" ---------- Custom Abbreviations {{{2
" add a shebang with the given filetype
inoreabbrev <expr> #!! "#!/usr/bin/env" . (empty(&filetype) ? '' : ' '.&filetype)



" -------------------- Plugin Configurations {{{1
" ---------- git-messenger {{{2
" ----- Configurations {{{3
let g:git_messenger_always_into_popup = v:true
let g:git_messenger_date_format = '%d.%m.%Y - %H:%M'
let g:git_messenger_no_default_mappings = v:true


" ----- Mappings {{{3
nmap <Leader>gb <Plug>(git-messenger)



" ---------- LSP (lspconfig, lspsaga, nvim-compe) {{{2
" ----- Configurations {{{3
lua <<EOF
require'lspconfig'.angularls.setup{}
require'lspconfig'.html.setup{}
require'lspconfig'.intelephense.setup{}
require'lspconfig'.jsonls.setup{}
require'lspconfig'.tsserver.setup{}
require'lspconfig'.vimls.setup{}
require'lspconfig'.vuels.setup{}
require'lspconfig'.yamlls.setup{}
EOF

autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()

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
nnoremap gd <CMD>lua vim.lsp.buf.definition()<CR>
nnoremap gi <CMD>lua vim.lsp.buf.implementation()<CR>
nnoremap gr <CMD>lua vim.lsp.buf.references()<CR>
nnoremap gy <CMD>lua vim.lsp.buf.type_definition()<CR>
nnoremap [g<CMD>Lspsaga diagnostic_jump_prev<CR>
nnoremap ]g <CMD>Lspsaga diagnostic_jump_next<CR>

nnoremap <Leader>cac <CMD>Lspsaga code_action<CR>
nnoremap <Leader>crn <CMD>Lspsaga rename<CR>
nnoremap <Leader>cf <CMD>lua vim.lsp.buf.formatting()<CR>
nnoremap <Leader>cc <CMD>Lspsaga lsp_finder<CR>
nnoremap <Leader>cl <CMD>Lspsaga show_line_diagnostics<CR>

nnoremap <Leader>cn <CMD>cnext<CR>
nnoremap <Leader>cp <CMD>cprev<CR>

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR> compe#confirm('<CR>')

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



" ---------- telescope {{{2
" ----- Configurations {{{3
lua << EOF
local actions = require('telescope.actions')

require('telescope').setup {
  defaults = {
    -- can be deleted as soon as I install ripgrep
    vimgrep_arguments = {
      'ag',
      '--vimgrep',
    },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
  },
}
EOF


" ----- Mappings {{{3
nnoremap <Leader><TAB> <CMD>lua require('telescope.builtin').builtin()<CR>
nnoremap <Leader>f, <CMD>lua require('telescope.builtin').file_browser()<CR>
" simulate vinegar (open current folder structure etc)
nnoremap <Leader>f. <CMD>lua require('telescope.builtin').file_browser({ cwd = vim.fn.expand("%:p:h") })<CR>
nnoremap <Leader>ff <CMD>lua require('telescope.builtin').git_files()<CR>
nnoremap <Leader><Leader>f <CMD>lua require('telescope.builtin').git_files({ layout_config = { preview_width = 0 } })<CR>
nnoremap <Leader>fb <CMD>lua require('telescope.builtin').buffers()<CR>
nnoremap <Leader>fg <CMD>lua require('telescope.builtin').git_status()<CR>
nnoremap <Leader>fa <CMD>lua require('telescope.builtin').live_grep()<CR>
nnoremap <Leader>fl <CMD>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>
" search repo for given word and open a fuzzy finder with it
nnoremap <Leader>fs <CMD>lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep for > ") })<CR>
" search repo for word under cursor and open a fuzzy finder with it
nnoremap <Leader>fw <CMD>lua require('telescope.builtin').grep_string()<CR>
