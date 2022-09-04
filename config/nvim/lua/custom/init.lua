vim.cmd([[
" custom textobject for indentations
onoremap <silent> ii :lua require('custom.textobjects').indent_inner_textobject()<CR>
xnoremap <silent> ii :<C-u>lua require('custom.textobjects').indent_inner_textobject()<CR>
onoremap <silent> ai :lua require('custom.textobjects').indent_around_textobject()<CR>
xnoremap <silent> ai :<C-u>lua require('custom.textobjects').indent_around_textobject()<CR>
]])
