" configure the status line
let g:lightline = {
  \   'colorscheme': 'powerline',
  \   'active': {
  \     'left': [ [ 'mode', 'paste' ],
  \               [ 'gitbranch' ],
  \               [ 'readonly', 'filename', 'modified' ] ],
  \     'right': [ [ 'lineinfo' ],
  \                [ 'percent' ],
  \                [ 'cocstatus', 'filetype', 'fileencoding', 'fileformat' ] ]
  \   },
  \   'component_function': {
  \     'gitbranch': 'FugitiveHead',
  \     'cocstatus': 'coc#status',
  \   },
  \ }

