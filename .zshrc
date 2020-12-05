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
antigen bundle z
antigen bundle docker
antigen bundle docker-compose
antigen bundle extract

# Load other plugins
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

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
alias vim="nvim"
alias vi="vim"
alias v="vim"
alias vv="vim ."
alias clip="xclip -sel clip"
alias open="xdg-open"
alias npmplease="rm -rf node_modules/ && rm -f package-lock.json && npm install"

# like normal z when used with arguments but displays an fzf prompt when used without.
unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}



# -------------------- Special --------------------
# add keybinding to open commandline in editor (CTRL-e)
bindkey "^e" edit-command-line

# enable completions
# compinit needs to be run, because plugins like docker have files that are not
# in the .zcompdump and so not loaded unless compinit is run (-C does not work)
autoload -U compinit && compinit
