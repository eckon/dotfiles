# -------------------- Path --------------------
test -d ~/.fnm;      and fish_add_path ~/.fnm
test -d /opt/zoxide; and fish_add_path /opt/zoxide



# -------------------- Source --------------------
type -q starship; and starship init fish | source; or echo "[!] No starship"
type -q fnm;      and fnm env            | source; or echo "[!] No fnm"
type -q zoxide;   and zoxide init fish   | source; or echo "[!] No zoxide"



# -------------------- Configuration --------------------
set -Ux EDITOR "nvim"
set -Ux VISUAL "nvim"
set fish_greeting



# -------------------- Alias/Functions/Abbreviations/Bindings --------------------
alias clip "xclip -sel clip"
alias ll   "LC_COLLATE=C ls -alF --color=auto --group-directories-first"
alias ssh  "TERM=xterm-256color command ssh"
alias vi   "vim"
alias vim  "nvim"


abbr -a npmplease "rm -rf node_modules/ && rm -f package-lock.json && npm install"
abbr -a de        "docker exec -it"
abbr -a dc        "docker compose"
abbr -a gco       "git checkout"


bind -M insert \cr "fzf-history (commandline -c); commandline -f repaint"


# https://github.com/junegunn/fzf/blob/master/shell/key-bindings.fish
function fzf-history --description "Search through history with fzf"
  history -z \
    | fzf --height 50% --query="$argv" --tiebreak=index --print0 --read0 \
    | read -lz result
  and commandline -- $result
end



# -------------------- Special --------------------
## ---------- Vi-Keybindings ----------
fish_vi_key_bindings

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

# vim:filetype=sh
