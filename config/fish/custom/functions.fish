# expansion of `!!` to be similar of bash/zsh etc.
function last_history_item; echo $history[1]; end
abbr --add !! --position anywhere --function last_history_item

# add vim-mode indicator
function fish_mode_prompt
  switch $fish_bind_mode
  case default
    set_color --bold blue
    echo 'N '
  case insert
    set_color --bold green
    echo 'I '
  case '*'
    set_color --bold red
    echo '* '
  end
  set_color normal
end
