setlocal spell
setlocal wrap
setlocal colorcolumn=
setlocal conceallevel=2

nnoremap <buffer> <Leader>ft <CMD>lua require('fzf-lua').grep({ search = '#TODO' })<CR>
nnoremap <buffer> <Leader>fd <CMD>lua require('fzf-lua').grep({ search = '#DONE' })<CR>
