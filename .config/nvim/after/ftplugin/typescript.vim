" Custom Commands
" fill quickfix with errors, do some formatting to have correct quickfix format
" path:line:col:message
command! -buffer CCRunEslint cexpr system("npx eslint -f unix '{src,apps}/**/*.ts' 2>/dev/null | awk 'length($0) > 20 { print $0 }'")
command! -buffer CCRunTsc    cexpr system("npx tsc 2>/dev/null | sed 's/[(,]/:/g' | sed 's/)//'")
