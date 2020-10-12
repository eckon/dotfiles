let g:fern#default_hidden = 1
let g:fern#renderer = 'nerdfont'
let g:fern#smart_cursor = 'hide'



map <silent><C-n> :Fern . -drawer -reveal=% -toggle<CR>
map <silent><C-j> :Fern %:h<CR>

function! FernInit() abort
  nmap <buffer> * <Plug>(fern-action-mark)
  nmap <buffer> - <Plug>(fern-action-open:split)
  nmap <buffer> \| <Plug>(fern-action-open:vsplit)
  nmap <buffer> D <Plug>(fern-action-remove)
  nmap <buffer> n <Plug>(fern-action-new-path)
  nmap <buffer> p <Plug>(fern-action-open:edit)<C-w><C-p>
  nmap <buffer> > <Plug>(fern-action-enter)
  nmap <buffer> < <Plug>(fern-action-leave)
endfunction

augroup FernGroup
  autocmd!
  autocmd FileType fern call FernInit()
augroup END

