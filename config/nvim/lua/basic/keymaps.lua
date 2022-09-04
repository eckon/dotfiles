vim.cmd([[
" disable annoying keys
nnoremap <F1> <Nop>
inoremap <F1> <Nop>
noremap U <Nop>

" rehighlight text after indenting
vnoremap < <gv
vnoremap > >gv

" center view after common jump actions
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

" append jump-commands for quickfix-list jumps
nnoremap [q <CMD>cprevious<CR>zz
nnoremap ]q <CMD>cnext<CR>zz
nnoremap [Q <CMD>cfirst<CR>zz
nnoremap ]Q <CMD>clast<CR>zz

" quickly update macro - use wanted register - press enter to execute
nnoremap <Leader>m :<C-u><C-r><C-r>='let @' . v:register . ' = ' . string(getreg(v:register))<CR><C-f><LEFT>
]])
