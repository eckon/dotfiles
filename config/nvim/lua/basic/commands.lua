vim.cmd([[
" quickly setup vim for pair programming
command! CCPairProgramming tabdo windo set norelativenumber

" open current buffer file in the browser (needs to be cloned over git with ssh)
command! CCBrowser
  \ !xdg-open $(
  \   git config --get remote.origin.url
  \     | sed 's/\.git//g'
  \     | sed 's/:/\//g'
  \     | sed 's/git@/https:\/\//'
  \ )/$(
  \   git config --get remote.origin.url | grep -q 'bitbucket.org'
  \     && echo 'src/master'
  \     || echo blob/$(git branch --show-current)
  \ )/%

" open current project and goto the current buffer file in vscode
command! CCVSCode !code $(pwd) -g %
]])
