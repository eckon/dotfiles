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

" for lsp completion
set completeopt=menuone,noselect

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

" ---------- custom status line {{{2
" initialisation of the status line
set statusline=
" mode
set statusline+=%4*%8(%{GetCurrentMode()}%)\ 
set statusline+=%-5((%{mode(1)})%)
" git head
set statusline+=%1*\ %{GetGitBranchName()}\ 
" readonly / filename / modified
set statusline+=%2*\ %t%m%r\ 
" end of line
set statusline+=%=
" filetype / filencoding / fileformat
set statusline+=%3*%{&filetype}\ %{&fenc?&fenc:&enc}\ %{&ff}\ 
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
  let git_branch_name = trim(system('git branch --show-current'))

  " check if command returns fatal error (no git repository)
  if git_branch_name =~ 'fatal'
    let git_branch_name = 'NO-GIT'
  end

  let g:git_branch_name = git_branch_name
endfunction

function! GetGitBranchName() abort
  return get(g:, 'git_branch_name', '')
endfunction

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
lua require'lspconfig'.angularls.setup{}
lua require'lspconfig'.html.setup{}
lua require'lspconfig'.intelephense.setup{}
lua require'lspconfig'.jsonls.setup{}
lua require'lspconfig'.tsserver.setup{}
lua require'lspconfig'.vimls.setup{}
lua require'lspconfig'.vuels.setup{}
lua require'lspconfig'.yamlls.setup{}

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

" show signatur when typing
autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()


" ----- Mappings {{{3
" alot of these have also basic implementations by native-lsp
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

" use default K if we have something in help
function! s:show_documentation() abort
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h ' . expand('<cword>')
  else
    " basic lsp: lua vim.lsp.buf.hover()
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
