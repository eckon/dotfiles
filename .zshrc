# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# set capslock to enter for easier escaping
setxkbmap -option caps:escape

# default editor
export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"

# tmux should use 256 colors
export TERM="xterm-256color"

# mute the beep/bell sound on error/completion etc.
unsetopt BEEP

# Path to your oh-my-zsh installation.
export ZSH="/home/eckon/.oh-my-zsh"

# Use power10k theme and configure it in .p10k.zsh
ZSH_THEME="powerlevel10k/powerlevel10k"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# hyphen-insensitive completion
HYPHEN_INSENSITIVE="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
    z
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    nvm
)

source $ZSH/oh-my-zsh.sh

# custom aliases
alias ls="ls --color=tty"
alias ll="ls -la"
alias dev="cd /home/eckon/Development"
alias grep="grep --color=auto"

# use for fzf app
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


###
### custom functions
###

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

