let g:fern#default_hidden = 1
let g:fern#renderer = 'nerdfont'



map <silent><C-n> :Fern . -drawer -reveal=% -toggle<CR>
map <silent><C-j> :Fern %:h<CR>

function! FernInit() abort
  " when interacting with the drawer -> hide it after selecting a file
  " also <CR> should not change root path but close/open folder structures
  nmap <buffer><expr><silent>
    \ <Plug>(fern-my-drawer-interactions)
    \ fern#smart#leaf(
    \   "\<Plug>(fern-action-open-or-expand):Fern . -drawer -toggle\<CR>",
    \   "\<Plug>(fern-action-expand)",
    \   "\<Plug>(fern-action-collapse)",
    \ )

  " differenciate between editor (current buffer) and drawer (side-navigation)
  " editor -> change root path with <CR> and do not toggle drawer
  " drawer -> just open/close folders and toggle drawer after selection
  nmap <buffer><expr>
    \ <Plug>(fern-my-cr)
    \ fern#smart#drawer(
    \   "\<Plug>(fern-my-drawer-interactions)",
    \   "\<Plug>(fern-action-open-or-enter)",
    \ )

  nmap <buffer> <CR> <Plug>(fern-my-cr)
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

