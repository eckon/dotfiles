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

ZSH_THEME="powerlevel9k/powerlevel9k"

# Prompt segments of powerlevel9k
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(user dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time)
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_from_right
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=

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

# use for thefuck app
eval $(thefuck --alias)

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
