if &modifiable
  setlocal conceallevel=0
  setlocal cursorcolumn
else
  nnoremap <buffer> q <C-w>q
endif

let b:miniindentscope_disable = v:true
