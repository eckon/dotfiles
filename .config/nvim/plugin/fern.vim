let g:fern#default_hidden = 1
let g:fern#renderer = 'nerdfont'



map <silent><C-n> :Fern . -drawer -reveal=% -toggle<CR>
map <silent><C-j> :Fern %:h<CR>

function! FernInit() abort
  " if in drawer -> close drawer after opening file
  " if not -> only open file (this is when its in the current buffer)
  nmap <buffer><expr>
  \ <Plug>(fern-my-open-or-open-and-close)
  \ fern#smart#drawer(
  \   "\<Plug>(fern-action-open)<C-n>",
  \   "\<Plug>(fern-action-open)",
  \ )

  " simluate 'normal' behaviour of enter
  " folder -> toggle open/close | file -> open it (use above to differ drawer)
  nmap <buffer><expr>
    \ <Plug>(fern-my-open-or-expand-or-collapse)
    \ fern#smart#leaf(
    \   "\<Plug>(fern-my-open-or-open-and-close)",
    \   "\<Plug>(fern-action-expand)",
    \   "\<Plug>(fern-action-collapse)",
    \ )

  nmap <buffer> <CR> <Plug>(fern-my-open-or-expand-or-collapse)
  nmap <buffer> * <Plug>(fern-action-mark)
  nmap <buffer> - <Plug>(fern-action-open:split)
  nmap <buffer> \| <Plug>(fern-action-open:vsplit)
  nmap <buffer> D <Plug>(fern-action-remove)
  nmap <buffer> n <Plug>(fern-action-new-path)
  nmap <buffer> p <Plug>(fern-action-open:edit)<C-w><C-p>
endfunction

augroup FernGroup
  autocmd!
  autocmd FileType fern call FernInit()
augroup END

