" Custom Commands
" fill quickfix with errors, do some formatting to have correct quickfix format
" path:line:col:message
command! -buffer CCRunEslint cexpr system("npx eslint -f unix '{src,apps}/**/*.ts' 2>/dev/null | awk 'length($0) > 20 { print $0 }'")
command! -buffer CCRunTsc    cexpr system("npx tsc 2>/dev/null | sed 's/[(,]/:/g' | sed 's/)//'")

" get content of provided tmux pane and parse it with given errorformat
command! -buffer -nargs=1 CCTmuxTsc
  \ set errorformat=%f:%l:%c\ -\ %m |
  \ cexpr system('tmux capture-pane -pJS - -t <args> | grep -E "^[a-z]+.*\.ts:[0-9]+:[0-9]+" | sed "s/ *$//" | tac | tail --lines=20') |
  \ set errorformat&

command! -buffer -nargs=1 CCTmuxJest
  \ set errorformat=at\ Object.<anonymous>\ (%f:%l:%c)%m |
  \ cexpr system('tmux capture-pane -pJS - -t <args> | grep -oE "at Object\.<anonymous> (.*)"') |
  \ set errorformat&
