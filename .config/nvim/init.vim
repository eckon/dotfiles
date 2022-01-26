" -------------------- Plugin Installations {{{1
call plug#begin()
  " General Tools {{{2
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'

  " Try out (not sure yet if I want to keep them)
  Plug 'phaazon/hop.nvim'

  " Treesitter {{{2
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'

  " LSP {{{2
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }

  " Debugger {{{2
  Plug 'mfussenegger/nvim-dap'
  Plug 'rcarriga/nvim-dap-ui'
  Plug 'theHamsta/nvim-dap-virtual-text'

  " Syntax/Styling/Appearance/Special {{{2
  Plug 'gruvbox-community/gruvbox'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'tmux-plugins/vim-tmux-focus-events'
  " }}}2
call plug#end()



" -------------------- General Configuration {{{1
let mapleader = "\<Space>"

set clipboard+=unnamedplus shell=bash mouse=a undofile title
set completeopt=menuone,noinsert,noselect
set magic lazyredraw ignorecase smartcase
set nowrap foldmethod=indent nofoldenable
set number relativenumber
set shiftwidth=2 tabstop=2 softtabstop=2 smartindent expandtab
set shortmess+=cA noshowmode
set signcolumn=yes
set splitbelow splitright
set updatetime=100
set wildmode=list:longest,list:full



" -------------------- Color/Style Configuration {{{1
colorscheme gruvbox
set cursorline colorcolumn=80,120,121
set list listchars=nbsp:¬,extends:»,precedes:«,lead:\ ,trail:·,space:\ ,tab:▸\ 
set scrolloff=5
set termguicolors

augroup HighlightYankedText
  autocmd!
  autocmd TextYankPost * silent! lua require('vim.highlight').on_yank()
augroup END



" -------------------- General Key Bindings / Commands {{{1
" ---------- Custom Key Bindings {{{2
" disable annoying keys
nnoremap <F1> <Nop>
inoremap <F1> <Nop>

" rehighlight text after indenting
vnoremap < <gv
vnoremap > >gv

" append jump-commands for quickfix-list jumps
nnoremap [q <CMD>cprevious<CR>zz
nnoremap ]q <CMD>cnext<CR>zz
nnoremap [Q <CMD>cfirst<CR>zz
nnoremap ]Q <CMD>clast<CR>zz

" quickly update macro - use wanted register - press enter to execute
nnoremap <Leader>m :<C-u><C-r><C-r>='let @'. v:register .' = '. string(getreg(v:register))<CR><C-f><LEFT>



" ---------- Custom Commands {{{2
" open current buffer file in the browser (needs to be cloned over git with ssh)
command! CCOpenProjectInBrowser
  \ !xdg-open $(
  \   git config --get remote.origin.url
  \     | sed 's/\.git//g'
  \     | sed 's/:/\//g'
  \     | sed 's/git@/https:\/\//'
  \ )/blob/$(
  \   git branch --show-current
  \ )/%

" open current project and goto the current buffer file in vscode
command! CCOpenProjectInVsCode !code $(pwd) -g %

" fill quickfix with errors, do some formatting to have correct quickfix format
" path:line:col:message
command! CCRunEslint cexpr system("npx eslint -f unix '{src,apps}/**/*.ts' 2>/dev/null | awk 'length($0) > 20 { print $0 }'")
command! CCRunTsc    cexpr system("npx tsc 2>/dev/null | sed 's/[(,]/:/g' | sed 's/)//'")

" git blame of current line
command! CCGitBlameLine execute "!git blame -L " .. line('.') .. "," .. line('.') .. " -- %"



" -------------------- Plugin Configurations {{{1
" ---------- Language Server Protocol (LSP) {{{2
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
  \   'coc-css',
  \   'coc-emmet',
  \   'coc-eslint8',
  \   'coc-prettier',
  \   'coc-toml',
  \   'coc-tsserver',
  \   'coc-vetur',
  \ ]


" ----- Mappings {{{3
nnoremap <silent>K :call <SID>show_documentation()<CR>
inoremap <silent><expr> <C-Space> coc#refresh()

nmap <silent>[g <Plug>(coc-diagnostic-prev)
nmap <silent>]g <Plug>(coc-diagnostic-next)
nmap <silent>gd <Plug>(coc-definition)
nmap <silent>gD <Plug>(coc-declaration)
nmap <silent>gr <Plug>(coc-references-used)
nmap <silent>gi <Plug>(coc-implementation)
nmap <silent>gI <Plug>(coc-type-definition)

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
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction



" ---------- Treesitter {{{2
" ----- Configurations {{{3
lua << EOF
require('nvim-treesitter.configs').setup({
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
    -- regex highlight is still better than TS highlight
    disable = { 'php', 'vim' },
  },
  context_commentstring = { enable = true },
})
EOF



" ---------- Fuzzy-Finder {{{2
" ----- Configurations {{{3
" enable to use ctrl-p/n in fzf window to cycle through history
let g:fzf_history_dir = '~/.local/share/fzf-history'


" ----- Mappings {{{3
" show all files of <range> parents folders from current file
nnoremap <Leader>f. <CMD>call fzf#vim#files(expand("%:p" . repeat(":h", v:count1)))<CR>
nnoremap <Leader>fa :Ag<Space>
nnoremap <Leader>fb <CMD>Buffers<CR>
nnoremap <Leader>ff <CMD>GFiles<CR>
nnoremap <Leader>fg <CMD>GFiles?<CR>
nnoremap <Leader>fl <CMD>BLines<CR>



" ---------- Git {{{2
" ----- Configurations {{{3
lua << EOF
require('gitsigns').setup({ keymaps = {} })
EOF


" ----- Mappings {{{3
nnoremap <Leader>gb <CMD>lua require('gitsigns').blame_line({ full = true })<CR>
nnoremap ]c <CMD>Gitsigns next_hunk<CR>
nnoremap [c <CMD>Gitsigns prev_hunk<CR>



" ---------- Statusline {{{2
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
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { 'filename' },
    lualine_x = { 'coc#status' ,'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  }
})
EOF



" ---------- Debugger {{{2
" ----- Configurations {{{3
lua << EOF
local dap = require('dap')
local dap_ui = require('dapui')
local dap_virtual_text = require('nvim-dap-virtual-text')

-- setup virtual text and ui
dap_ui.setup()
dap_virtual_text.setup()

-- open/close ui on dap events
dap.listeners.after.event_initialized["dapui_config"] = function() dap_ui.open()  end
dap.listeners.before.event_terminated["dapui_config"] = function() dap_ui.close() end
dap.listeners.before.event_exited["dapui_config"]     = function() dap_ui.close() end

-- setup basic dap (manually install node2 debugger)
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#Javascript
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { vim.fn.stdpath('data') .. '/dap_debugger/vscode-node-debug2/out/src/nodeDebug.js' },
}

dap.configurations.typescript = {{ name = 'Attach to process', type = 'node2', request = 'attach' }}
EOF


" ----- Mappings {{{3
nnoremap <silent> <Leader>db :lua require('dap').toggle_breakpoint()<CR>
nnoremap <silent> <Leader>dB :lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <Leader>dE :lua require('dap').set_exception_breakpoints({ 'all' })<CR>
nnoremap <silent> <Leader>dK :lua require('dap.ui.widgets').hover()<CR>

nnoremap <silent> <Leader>dd :lua require('dap').continue()<CR>
nnoremap <silent> <Leader>dh :lua require('dap').step_into()<CR>
nnoremap <silent> <Leader>dj :lua require('dap').step_over()<CR>
nnoremap <silent> <Leader>dl :lua require('dap').step_out()<CR>



" ---------- Filetree {{{2
" ----- Configurations {{{3
let g:nvim_tree_quit_on_open = 1
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
  view = { hide_root_folder = true,
    width = '35%',
    relativenumber = true,
    -- unbind hide for my default H binding (Hop)
    mappings = { list = {{ key = 'H' }} },
  },
})
EOF


" ----- Mappings {{{3
nnoremap <Leader>. <CMD>NvimTreeFindFileToggle<CR>
nnoremap <Leader>, <CMD>NvimTreeToggle<CR>



" ---------- hop {{{2
" ----- Configurations {{{3
lua << EOF
require('hop').setup()
EOF


" ----- Mappings {{{3
noremap H <CMD>HopChar1<CR>

" vim:foldmethod=marker
