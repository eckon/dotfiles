" configure the window when using fzf inside of vim (and only inside of vim)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
let $FZF_DEFAULT_OPTS = "--ansi --preview-window 'right:60%' --layout reverse --margin=1,2"
" enable to use ctrl-p/n in fzf window to cycle through history
let g:fzf_history_dir = '~/.local/share/fzf-history'

