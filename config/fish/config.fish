# -------------------- Sources --------------------
test -d /opt/homebrew;      and eval "$(/opt/homebrew/bin/brew shellenv)"
test -d /home/linuxbrew;    and eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

test -d ~/.local/share/fnm; and fish_add_path ~/.local/share/fnm
test -d ~/.local/bin;       and fish_add_path ~/.local/bin
test -d ~/.cargo/bin;       and fish_add_path ~/.cargo/bin

type --query starship;      and starship init fish | source; or echo "[!] No starship"
type --query fnm;           and fnm env            | source; or echo "[!] No fnm"
type --query zoxide;        and zoxide init fish   | source; or echo "[!] No zoxide"
type --query fzf;           and fzf --fish         | source; or echo "[!] No fzf"



# -------------------- Configurations --------------------
set -Ux EDITOR              "nvim"
set -Ux VISUAL              "nvim"
set -Ux MANPAGER            "nvim +Man!"
set -Ux LESS                "--mouse --wheel-lines=5 -r"
set -Ux RIPGREP_CONFIG_PATH "$HOME/.config/ripgreprc"
set fish_greeting

# NOTE: use fish_config to set colors etc.
fish_vi_key_bindings



# -------------------- Alias/Abbreviations --------------------
alias clip "xclip -sel clip"
alias ll   "LC_COLLATE=C ls -alFh --color=auto --group-directories-first"
alias ssh  "TERM=xterm-256color command ssh"
alias vi   "vim -u NONE"
alias vim  "nvim"

# not as safe as `sudoedit` but I rarely need it, to should be fine
abbr --add sudo-vim "sudo -Es nvim"

# quickly delete locally installed packages
abbr --add npmplease  "rm -rf node_modules/ && rm -f package-lock.json && npm install"
abbr --add yarnplease "rm -rf node_modules/ && rm -f yarn.lock && yarn install"

abbr --add j  "tmux-jump"
abbr --add js "tmux-jumpstart"

abbr --add --command git R \
     --set-cursor "rebase --interactive HEAD~%"

abbr --add --command git S \
     --set-cursor \
     --position anywhere "switch % && git pull && git switch - && git rebase -"

abbr --add retry \
     --set-cursor \
     --position anywhere "while not %; echo 'Command failed. Retrying...'; sleep 1; end"

# quickly add a diff between two files, uses custom git word diff alias
abbr --add compare \
     --set-cursor \
     --position anywhere "git wdiff (cat % | sort | psub) (cat second.txt | sort | psub)"

# expansion of !!
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
