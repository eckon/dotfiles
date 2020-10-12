" configure the window when using fzf inside of vim (and only inside of vim)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
let $FZF_DEFAULT_OPTS = "--ansi --preview-window 'right:60%' --layout reverse --margin=1,2"



" Call ag and pass the hidden flag to also show dotfiles
" Taken from https://github.com/junegunn/fzf.vim/issues/92 and modified
command! -bang -nargs=* AgHidden
  \ call fzf#vim#ag(
  \   <q-args>,
  \   '--hidden --ignore ".git"',
  \   <bang>0
  \ )

" enable usage of ctrl-r (e.g. to paste vim buffer) in fzf windows
tnoremap <expr> <C-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'"'

" find files, lines, content, mappings, commits in project and open buffers
nnoremap <C-_> :AgHidden<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <C-f> :BLines<CR>
nnoremap <C-h> :BCommits<CR>
nnoremap <C-p> :GFiles<CR>
nnoremap <C-m> :Maps<CR>

