" set coc extensions that should always be installed
" essential
let g:coc_global_extensions = [
  \   'coc-emmet',
  \   'coc-yank',
  \   'coc-pairs',
  \   'coc-ultisnips',
  \   'coc-marketplace',
  \ ]
" general
let g:coc_global_extensions += [
  \   'coc-json',
  \   'coc-vimlsp',
  \   'coc-html',
  \   'coc-yaml',
  \   'coc-docker',
  \ ]
" specific
let g:coc_global_extensions += [
  \   'coc-tsserver',
  \   'coc-css',
  \   'coc-prettier',
  \   'coc-eslint',
  \   'coc-phpls',
  \   'coc-angular',
  \   'coc-go',
  \   'coc-python',
  \   'coc-java',
  \   'coc-rust-analyzer',
  \ ]



autocmd CursorHold * silent call CocActionAsync('highlight')

" use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" goto code navigation and other coc commands
nmap <Leader>ac <Plug>(coc-codeaction)
nmap <Leader>qf <Plug>(coc-fix-current)
nmap <Leader>rn <Plug>(coc-rename)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> <Leader>f <Plug>(coc-format)
xmap <silent> <Leader>f <Plug>(coc-format-selected)

" use <C-space> to trigger coc code completion
inoremap <silent><expr> <C-space> coc#refresh()

" use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <CR> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" function to show documentation in a preview window
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

