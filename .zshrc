# -------------------- Exports --------------------
export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"



# -------------------- Configuration --------------------
unsetopt BEEP

# make ssh/scp/etc. <tab>-completion easier when using the .ssh config file/etc.
zstyle ":completion:*:(ssh|scp|ftp|sftp):*" hosts $hosts
zstyle ":completion:*:(ssh|scp|ftp|sftp):*" users $users



# -------------------- Plugins --------------------
source ~/.antigen/antigen.zsh

antigen use oh-my-zsh

# Load oh-my-zsh plugins
antigen bundle docker
antigen bundle docker-compose
antigen bundle extract
antigen bundle z

# Load other plugins
antigen bundle momo-lab/zsh-abbrev-alias
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply



# -------------------- Source --------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.cargo/env ] && source ~/.cargo/env
[ -f ~/.fnm/fnm ] && export PATH=$HOME/.fnm:$PATH && eval "$(fnm env)"
[ -x "$(command -v starship)" ] && eval "$(starship init zsh)"



# -------------------- Alias --------------------
alias dev="cd $HOME/Development"
alias grep="grep --color=auto"
alias ll="LC_COLLATE=C ls -alF --color=auto --group-directories-first"
alias npmplease="rm -rf node_modules/ && rm -f package-lock.json && npm install"
alias vi="vim"
alias vim="nvim"

# aliases that will be expanded (for better readability/history)
abbrev-alias clip="xclip -sel clip"
abbrev-alias d="docker"
abbrev-alias dc="docker-compose"
abbrev-alias dstop="docker stop \$(docker ps -q -a)"
abbrev-alias gc="git checkout"
abbrev-alias gp="git pull"
abbrev-alias gs="git status"
abbrev-alias nr="npm run"
abbrev-alias open="xdg-open"
abbrev-alias ta="tmux attach -t"
abbrev-alias tn="tmux new-session -s"
abbrev-alias v="vim"
abbrev-alias vv="vim ."



# -------------------- Special --------------------
# add keybinding to open commandline in editor (CTRL-v CTRL-v)
bindkey "^v^v" edit-command-line

# enable completions
# compinit needs to be run, because plugins like docker have files that are not
# in the .zcompdump and so not loaded unless compinit is run (-C does not work)
autoload -U compinit && compinit
