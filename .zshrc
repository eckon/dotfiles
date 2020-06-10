# -------------------- Special --------------------
# Enable Powerlevel10k instant prompt, should be ontop of dot file
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi



# -------------------- Exports --------------------
export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
export TERM="xterm-256color"
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
alias ll="ls -la"
alias v="nvim"
alias cp="cp -v"



# -------------------- Functions --------------------
## from https://github.com/junegunn/fzf/wiki/examples#general
# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() (
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
)

# fuzzy grep open via ag
vg() {
  local file

  file="$(ag --nobreak --noheading $@ | fzf -0 -1 | awk -F: '{print $1}')"

  if [[ -n $file ]]
  then
    ${EDITOR:-vim} $file
  fi
}



# -------------------- Special --------------------
# use to init some plugins (docker, docker-compose, probably others as well)
autoload -Uz compinit && compinit -i
