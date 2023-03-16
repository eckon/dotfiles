# -------------------- Path --------------------
test -d ~/.fnm;       and fish_add_path ~/.fnm
test -d ~/.local/bin; and fish_add_path ~/.local/bin
test -d ~/.cargo/bin; and fish_add_path ~/.cargo/bin



# -------------------- Source --------------------
type --query starship; and starship init fish | source; or echo "[!] No starship"
type --query fnm;      and fnm env            | source; or echo "[!] No fnm"
type --query zoxide;   and zoxide init fish   | source; or echo "[!] No zoxide"



# -------------------- Configuration --------------------
set -Ux EDITOR    "nvim"
set -Ux VISUAL    "nvim"
set -Ux LESS      "--mouse --wheel-lines=5 -r"
set fish_greeting


fzf_key_bindings
fish_vi_key_bindings



# -------------------- Alias/Abbreviations --------------------
alias clip "xclip -sel clip"
alias ll   "LC_COLLATE=C ls -alFh --color=auto --group-directories-first"
alias ssh  "TERM=xterm-256color command ssh"
alias vi   "nvim --cmd \"let g:run_minimal=1\""
alias vim  "nvim"


abbr --add npmplease "rm -rf node_modules/ && rm -f package-lock.json && npm install"
abbr --add j         "tmux-jump"
abbr --add ta        "tmux attach -t"
abbr --add tt        "tmux new -s"

# expansion of !! (>= fish v.3.6.0)
function last_history_item; echo $history[1]; end
abbr --add !! --position anywhere --function last_history_item


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
