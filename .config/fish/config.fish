# -------------------- Path --------------------
test -d ~/.fnm; and fish_add_path ~/.fnm
test -d /opt/zoxide; and fish_add_path /opt/zoxide



# -------------------- Source --------------------
# test example
# test -n "$FZF_TMUX"; or set FZF_TMUX 0
type -q starship; and starship init fish | source
type -q fnm; and fnm env | source
type -q zoxide; and zoxide init fish | source



# -------------------- Configuration --------------------
set -Ux EDITOR nvim
set -Ux VISUAL nvim

set fish_greeting "Testing Fish, if used update: README(fish, zoxide, others), Better config, maybe use sh instead of vim-fish"



# -------------------- Alias/Function/Abbreviation --------------------
alias clip "xclip -sel clip"
alias dev "cd $HOME/Development"
alias ll "LC_COLLATE=C ls -alF --color=auto --group-directories-first"
alias open "xdg-open"
# this is needed because most servers do not have kitty config yet so it would break the colors & some keys on a server
alias ssh "TERM=xterm-256color command ssh"
alias vi "vim"
alias vim "nvim"


abbr -a npmplease "rm -rf node_modules/ && rm -f package-lock.json && npm install"
abbr -a de "docker exec -it"
abbr -a dc "docker compose"
abbr -a gc "git checkout"


# search history with fzf (function, because alias does not work witj "read")
# https://github.com/junegunn/fzf/blob/master/shell/key-bindings.fish
function h
  history -z | fzf --height 25% --tiebreak=index --print0 --read0 | read -lz result
  and commandline -- $result
end



# -------------------- Special --------------------
## ---------- Vim ----------
fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_insert line

# add vim-mode indicator
function fish_mode_prompt
  switch $fish_bind_mode
  case default
    set_color --bold blue
    echo 'N'
  case insert
    set_color --bold green
    echo 'I'
  case '*'
    set_color --bold red
    echo '~'
  end
  echo ' '
  set_color normal
end
