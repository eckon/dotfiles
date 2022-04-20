" -------------------- Plugin Installations
call plug#begin()
  " General Tools
  Plug 'andymass/vim-matchup'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'phaazon/hop.nvim'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-sleuth'
  Plug 'tpope/vim-surround'

  " Treesitter
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'

  " LSP
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }

  " Debugger
  Plug 'puremourning/vimspector'

  " Syntax/Styling/Appearance/Special
  Plug 'gruvbox-community/gruvbox'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'tmux-plugins/vim-tmux-focus-events'
call plug#end()



" -------------------- General Configuration
let mapleader = "\<Space>"

" matchit breaks visual % inside of global command e.g.: 'g/foo/norm f(v%d'
let loaded_matchit = 1

set clipboard+=unnamedplus shell=bash mouse=a undofile noswapfile title
set completeopt=menuone,noinsert,noselect
set magic lazyredraw ignorecase smartcase
set nowrap foldmethod=indent nofoldenable
set number relativenumber
set shiftwidth=2 tabstop=2 softtabstop=2 smartindent expandtab
set shortmess+=c noshowmode
set signcolumn=yes
set splitbelow splitright
set updatetime=100
set wildmode=list:longest,list:full



" -------------------- Color/Style Configuration
colorscheme gruvbox
set cursorline colorcolumn=80,120,121
set list listchars=nbsp:¬,extends:»,precedes:«,lead:\ ,trail:·,space:\ ,tab:▸\ 
set scrolloff=5 sidescrolloff=5
set termguicolors



" -------------------- Autocommands
augroup HighlightYankedText
  autocmd!
  autocmd TextYankPost * silent! lua require('vim.highlight').on_yank()
augroup END

augroup RestoreCursor
  autocmd!
  autocmd BufReadPost *
    \ if &ft !~# 'commit\|rebase' && line("'\"") >= 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif
augroup END



" -------------------- General Key Bindings / Commands
" ---------- Custom Key Bindings
" disable annoying keys
noremap <F1> <Nop>
noremap U <Nop>

" rehighlight text after indenting
vnoremap < <gv
vnoremap > >gv

" append jump-commands for quickfix-list jumps
nnoremap [q <CMD>cprevious<CR>zz
nnoremap ]q <CMD>cnext<CR>zz
nnoremap [Q <CMD>cfirst<CR>zz
nnoremap ]Q <CMD>clast<CR>zz

" stick cursor in the center of the screen for easier scrolling
nnoremap <expr> <F1> &l:scrolloff == -1 ? ':setlocal scrolloff=999<CR>' : ':setlocal scrolloff=-1<CR>'

" quickly update macro - use wanted register - press enter to execute
nnoremap <Leader>m :<C-u><C-r><C-r>='let @' . v:register . ' = ' . string(getreg(v:register))<CR><C-f><LEFT>



" ---------- Custom Commands
" quickly setup vim for pair programming
command! CCPairProgramming tabdo windo set norelativenumber

" open current buffer file in the browser (needs to be cloned over git with ssh)
command! CCOpenProjectInBrowser
  \ !xdg-open $(
  \   git config --get remote.origin.url
  \     | sed 's/\.git//g'
  \     | sed 's/:/\//g'
  \     | sed 's/git@/https:\/\//'
  \ )/$(
  \   git config --get remote.origin.url | grep -q 'bitbucket.org'
  \     && echo 'src/master'
  \     || echo blob/$(git branch --show-current)
  \ )/%

" open current project and goto the current buffer file in vscode
command! CCOpenProjectInVsCode !code $(pwd) -g %



" -------------------- Plugin Configurations
" ---------- Language Server Protocol (LSP)
" ----- Configurations
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
  \   'coc-css',
  \   'coc-emmet',
  \   'coc-eslint8',
  \   'coc-prettier',
  \   'coc-toml',
  \   'coc-tsserver',
  \   'coc-vetur',
  \ ]


" ----- Mappings
nnoremap g? <CMD>CocOutline<CR>
nnoremap <silent>K :call <SID>show_documentation()<CR>
inoremap <silent><expr> <C-Space> coc#refresh()

nmap <silent>[g <Plug>(coc-diagnostic-prev)
nmap <silent>]g <Plug>(coc-diagnostic-next)
nmap <silent>gd <Plug>(coc-definition)
nmap <silent>gD <Plug>(coc-type-definition)
nmap <silent>gr <Plug>(coc-references-used)

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

" use <CR> to confirm completion
if exists('*complete_info')
  inoremap <expr> <CR> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<CR>"
else
  imap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
endif

function! s:show_documentation() abort
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'h ' . expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . ' ' . expand('<cword>')
  endif
endfunction



" ---------- Treesitter
" ----- Configurations
lua << EOF
require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  highlight = {
    enable = true,
    -- regex highlight is still better than Treesitter highlight
    disable = { 'php', 'vim' },
  },
  indent = { enable = true },
  incremental_selection = { enable = true },
  context_commentstring = { enable = true },
  matchup = { enable = true },
})
EOF



" ---------- Fuzzy-Finder
" ----- Configurations
" enable to use ctrl-p/n in fzf window to cycle through history
let g:fzf_history_dir = '~/.local/share/fzf-history'


" ----- Mappings
" show all files of <range> parents folders from current file
nnoremap <Leader>f. <CMD>call fzf#vim#files(expand('%:p' . repeat(':h', v:count1)))<CR>
nnoremap <Leader>fa :Ag<Space>
nnoremap <Leader>fb <CMD>Buffers<CR>
nnoremap <Leader>ff <CMD>GFiles<CR>
nnoremap <Leader>fg <CMD>GFiles?<CR>
nnoremap <Leader>fl <CMD>BLines<CR>



" ---------- Git
" ----- Configurations
lua << EOF
require('gitsigns').setup({ keymaps = {} })
EOF


" ----- Mappings
nnoremap <Leader>gb <CMD>lua require('gitsigns').blame_line({ full = true })<CR>
nnoremap ]c <CMD>Gitsigns next_hunk<CR>
nnoremap [c <CMD>Gitsigns prev_hunk<CR>



" ---------- Statusline
" ----- Configurations
lua << EOF
require('lualine').setup({
  options = {
    component_separators = {},
    globalstatus = true,
    icons_enabled = false,
    section_separators = {},
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { 'filename' },
    lualine_x = { 'coc#status', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
})
EOF



" ---------- Debugger
" ----- Configurations
let g:vimspector_install_gadgets = [ 'vscode-node-debug2' ]


" ----- Mappings
nnoremap <Leader>dd <CMD>call vimspector#Launch()<CR>
nnoremap <Leader>ds <CMD>call vimspector#Reset()<CR>
nnoremap <Leader>dc <CMD>call vimspector#Continue()<CR>
nnoremap <Leader>dC <CMD>call vimspector#RunToCursor()<CR>
nnoremap <Leader>dr <CMD>call vimspector#Restart()<CR>

nnoremap <Leader>db <CMD>call vimspector#ToggleBreakpoint()<CR>
nnoremap <Leader>dB <CMD>call vimspector#ClearBreakpoints()<CR>

nnoremap <Leader>dl <CMD>call vimspector#StepOut()<CR>
nnoremap <Leader>dh <CMD>call vimspector#StepInto()<CR>
nnoremap <Leader>dj <CMD>call vimspector#StepOver()<CR>

nmap <leader>di <Plug>VimspectorBalloonEval
xmap <leader>di <Plug>VimspectorBalloonEval



" ---------- Filetree
" ----- Configurations
let g:nvim_tree_add_trailing = 1
let g:nvim_tree_group_empty = 1
let g:nvim_tree_show_icons = {
  \   'git': 0,
  \   'folders': 0,
  \   'files': 0,
  \   'folder_arrows': 0,
  \ }

lua << EOF
require('nvim-tree').setup({
  git = { ignore = false },
  actions = { open_file = { quit_on_open = true } },
  view = {
    hide_root_folder = true,
    relativenumber = true,
    width = '35%',
  },
})
EOF


" ----- Mappings
nnoremap <Leader>. <CMD>NvimTreeFindFileToggle<CR>



" ---------- hop
" ----- Configurations
lua << EOF
require('hop').setup()
EOF


" ----- Mappings
noremap H <CMD>HopChar1<CR>
