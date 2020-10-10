let g:fern#default_hidden = 1
let g:fern#renderer = 'nerdfont'

map <silent><C-n> :Fern . -drawer -reveal=% -toggle<Cr>
