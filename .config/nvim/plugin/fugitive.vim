" quick actions for git status in the same buffer
nmap <silent> <Leader>gs :Gedit :<CR>
nmap <Leader>gd :Gdiffsplit<CR>

" quick actions for git merge conflicts left side 'f' (merge into) right 'j'
nmap <Leader>gf :diffget //2<CR>
nmap <Leader>gj :diffget //3<CR>
