" general settings
setlocal shiftwidth=4 tabstop=4 softtabstop=4


" special for bighost !!! can be deleted when its not being used !!!
"" this needs a 'swarmX-bighost-dev' in the .ssh/config to work
"" add general command for all buffers (after php buffer)
command! BighostUpload !scp %:p swarmX-bighost-dev:/%
"" use buffer so that it is only useable in a .php buffer
map <buffer><Leader><Leader>u :w <Bar> BighostUpload<CR>
