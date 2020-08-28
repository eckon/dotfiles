# -------------------- Special --------------------
# Enable Powerlevel10k instant prompt, should be ontop of dot file
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi



# -------------------- Exports --------------------
export EDITOR="nvim"
export VISUAL="nvim"
export ZSH="$HOME/.oh-my-zsh"



# -------------------- Configuration --------------------
unsetopt BEEP
HYPHEN_INSENSITIVE="true"

# Use power10k theme and configure it in .p10k.zsh
ZSH_THEME="powerlevel10k/powerlevel10k"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Make ssh/scp/etc. <tab>-completion easier when using the .ssh config file/etc.
zstyle ':completion:*:(ssh|scp|ftp|sftp):*' hosts $hosts
zstyle ':completion:*:(ssh|scp|ftp|sftp):*' users $users



# -------------------- Plugins --------------------
plugins=(
  docker
  docker-compose
  git
  kubectl
  ng
  nvm
  tmux
  z
  zsh-autosuggestions
  zsh-syntax-highlighting
)



# -------------------- Source --------------------
source $ZSH/oh-my-zsh.sh

# use for fzf app
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh



# -------------------- Alias --------------------
alias dev="cd $HOME/Development"
alias grep="grep --color=auto"
alias ll="LC_COLLATE=C ls -alF --color=auto --group-directories-first"
alias vim="nvim"
alias vi="vim"
alias v="vim"
alias vv="vim ."
alias cp="cp -v"
alias clip="xclip -sel clip"
alias open="xdg-open"
alias npmplease="rm -rf node_modules/ && rm -f package-lock.json && npm install"



# -------------------- Special --------------------
# vi mode on zsh
bindkey -v
KEYTIMEOUT=1
## when in normal mode press <CTRL>-V to open editor to edit command
bindkey -M vicmd "^V" edit-command-line

# use to init some plugins (docker, docker-compose, probably others as well)
autoload -Uz compinit && compinit -i

