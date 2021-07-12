# -------------------- Path --------------------
test -d ~/.fnm;       and fish_add_path ~/.fnm
test -d ~/.local/bin; and fish_add_path ~/.local/bin



# -------------------- Source --------------------
type -q starship; and starship init fish | source; or echo "[!] No starship"
type -q fnm;      and fnm env            | source; or echo "[!] No fnm"
type -q zoxide;   and zoxide init fish   | source; or echo "[!] No zoxide"



# -------------------- Configuration --------------------
set -Ux EDITOR "nvim"
set -Ux VISUAL "nvim"
set fish_greeting


fzf_key_bindings
fish_vi_key_bindings



# -------------------- Alias/Abbreviations --------------------
alias clip "xclip -sel clip"
alias ll   "LC_COLLATE=C ls -alF --color=auto --group-directories-first"
alias ssh  "TERM=xterm-256color command ssh"
alias vi   "vim"
alias vim  "nvim"


abbr -a npmplease "rm -rf node_modules/ && rm -f package-lock.json && npm install"
abbr -a de        "docker exec -it"
abbr -a dc        "docker compose"
abbr -a gco       "git checkout"
abbr -a l         "lazygit"
abbr -a ta        "tmux attach -t"
abbr -a tt        "tmux new -s"



# -------------------- Special --------------------
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

# vim:filetype=fish
