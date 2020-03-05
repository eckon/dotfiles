# tmux should use 256 colors
export TERM="xterm-256color"

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
