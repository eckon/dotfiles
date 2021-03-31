" vim:foldmethod=marker

call plug#begin()
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
call plug#end()



" -------------------- General Configuration {{{1
let mapleader = "\<Space>"

" ftp and plugins will still be loaded in vscode
set clipboard+=unnamedplus
set hlsearch ignorecase incsearch magic smartcase
set shiftwidth=2 tabstop=2 softtabstop=2 smarttab autoindent smartindent expandtab
set showcmd showmatch showmode
set timeoutlen=1000 updatetime=100



" -------------------- Color/Style Configuration {{{1
augroup HighlightYankedText
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END



" -------------------- General Key Bindings / Commands / Abbreviations {{{1
" ---------- Custom Key Bindings {{{2
" rehighlight text after indenting
vnoremap < <gv
vnoremap > >gv

" extend redraw of screen with hiding the highlight of search results
nnoremap <C-l> <CMD>nohlsearch<CR><C-l>

" general mappings of the vscode plugin can be found:
" https://github.com/asvetliakov/vscode-neovim#vscode-specific-features-and-differences
"
" to keep it more vim-style, link some of the mappings to other maps, like:
"
" trigger hover
nmap K gh
" show references
nmap gr gH
