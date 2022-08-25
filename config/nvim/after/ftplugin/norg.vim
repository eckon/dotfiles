setlocal spell
setlocal colorcolumn=
setlocal conceallevel=2

iabbrev <expr> <buffer> TODAY "^" .. trim(system("date +'%d.%m.%Y'")) .. "^"
