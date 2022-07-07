setlocal spell
setlocal wrap
setlocal colorcolumn=
setlocal conceallevel=2

nnoremap <buffer> <Leader>ft <CMD>lua require('fzf-lua').grep({ search = '#TODO' })<CR>

iabbrev <expr> <buffer> currd trim(system("date +'%d.%m.%Y'"))
