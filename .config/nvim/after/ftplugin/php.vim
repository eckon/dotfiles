" general settings
set shiftwidth=4 tabstop=4


" special for bighost !!! can be deleted when its not being used !!!
"" this needs a 'swarmX-bighost-dev' in the .ssh/config to work
map <Leader><Leader>u :w \| !scp %:p swarmX-bighost-dev:/%<CR>

