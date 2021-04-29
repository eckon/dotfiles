" My custom status line
" split into its own plugin, because I rarely change it

if exists('g:vscode')
  " do not use custom status line in vscode
else
  " initialisation of the status line
  set statusline=
  " mode
  set statusline+=%4*%8(%{GetCurrentMode()}%)\ 
  set statusline+=%-5((%{mode(1)})%)
  " git head
  set statusline+=%1*\ %{GetGitBranchName()}\ 
  " readonly / filename / modified
  set statusline+=%2*\ %t%m%r\ 
  " end of line
  set statusline+=%=
  " filetype / filencoding / fileformat
  set statusline+=%3*%{coc#status()}\ %{&filetype}\ %{&fenc?&fenc:&enc}\ %{&ff}\ 
  " percantage of file / line number / column number
  set statusline+=%1*\ %4(%p%%%)\ \|\ %-6(%l:%c%)\ 

  " highlight colors mainly for status line colors/styling
  " gruvbox color palette
  let colors = {
    \   'black': '#282828',
    \   'white': '#ebdbb2',
    \   'red': '#fb4934',
    \   'green': '#b8bb26',
    \   'blue': '#83a598',
    \   'yellow': '#fe8019',
    \   'gray': '#a89984',
    \   'darkgray': '#3c3836',
    \   'lightgray': '#504945',
    \   'inactivegray': '#7c6f64',
    \ }

  highlight User1 cterm=NONE ctermfg=white  ctermbg=darkgray
  execute 'highlight User1 gui=NONE guifg=' . g:colors.white . ' guibg=' . g:colors.lightgray
  highlight User2 cterm=NONE ctermfg=yellow ctermbg=black
  execute 'highlight User2 gui=NONE guifg=' . g:colors.gray . ' guibg=' . g:colors.darkgray
  highlight User3 cterm=NONE ctermfg=grey   ctermbg=black
  execute 'highlight User3 gui=NONE guifg=' . g:colors.gray . ' guibg=' . g:colors.darkgray
  highlight User4 cterm=bold ctermfg=black ctermbg=darkblue
  execute 'highlight User4 gui=bold guifg=' . g:colors.black . ' guibg=' . g:colors.blue

  " helper functions for status line
  function! GetCurrentMode() abort
    " table for different modes
    let modeTranslation={
      \   'n': 'NORMAL',
      \   'v': 'VISUAL',
      \   'V': 'V-Line',
      \   "\<C-v>": 'V-Block',
      \   'i': 'INSERT',
      \   'R': 'REPLACE',
      \   'c': 'COMMAND',
      \   't': 'TERM',
      \ }

    let mode = mode()
    " use get instead of [] to have a default value if we run into other modes
    return get(modeTranslation, mode, 'NOT-SET')
  endfunction

  " helper functions to get git branch name but only set it when needed
  augroup GitBranchName
    autocmd!
    autocmd BufEnter,FocusGained,FocusLost * call SetGitBranchName()
  augroup END

  function! SetGitBranchName() abort
    let git_branch_name = trim(system('git branch --show-current'))

    " check if command returns fatal error (no git repository)
    if git_branch_name =~ 'fatal'
      let git_branch_name = 'NO-GIT'
    end

    let g:git_branch_name = git_branch_name
  endfunction

  function! GetGitBranchName() abort
    return get(g:, 'git_branch_name', '')
  endfunction
endif
