" set errorformat to manually update the quickfix list
setlocal errorformat=%f\|%l\ col\ %c\|%m

" way of easily update the quickfix list
" set `modifiable` do changes in buffer and run this command
command! -buffer CCQuickfixUpdate cgetbuffer
