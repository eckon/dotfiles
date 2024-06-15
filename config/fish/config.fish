# -------------------- Sources --------------------
test -d /home/linuxbrew;    and eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

test -d ~/.local/share/fnm; and fish_add_path ~/.local/share/fnm
test -d ~/.local/bin;       and fish_add_path ~/.local/bin
test -d ~/.cargo/bin;       and fish_add_path ~/.cargo/bin

type --query starship; and starship init fish | source; or echo "[!] No starship"
type --query fnm;      and fnm env            | source; or echo "[!] No fnm"
type --query zoxide;   and zoxide init fish   | source; or echo "[!] No zoxide"



# -------------------- Configurations --------------------
set -Ux EDITOR              "nvim"
set -Ux VISUAL              "nvim"
set -Ux LESS                "--mouse --wheel-lines=5 -r"
set -Ux RIPGREP_CONFIG_PATH "$HOME/.config/ripgreprc"
set fish_greeting

fish_vi_key_bindings



# -------------------- Alias/Abbreviations --------------------
alias clip "xclip -sel clip"
alias ll   "LC_COLLATE=C ls -alFh --color=auto --group-directories-first"
alias ssh  "TERM=xterm-256color command ssh"
alias vi   "nvim --cmd \"let g:run_minimal=1\""
alias vim  "nvim"

abbr --add npmplease       "rm -rf node_modules/ && rm -f package-lock.json && npm install"
abbr --add j               "tmux-jump"
abbr --add ji              "tmux-interactive-jump"
abbr --add ta              "tmux attach -t"
abbr --add tt              "tmux new -s"
abbr --add rgg \
     --position anywhere \
     --set-cursor          "rg --json \"%\" | delta"

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
