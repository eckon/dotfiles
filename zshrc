# Show explicitly that I am in zsh
# as this is not my default shell anymore and mainly used as a fallback
echo "----------"
echo "Init zshrc"
echo "----------"


# Info (taken from my past README.md [after changing to fish])
# [zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH) _with_ [antigen](https://github.com/zsh-users/antigen)
# install antigen in `~/.antigen/antigen.zsh` (mentioned in `.zshrc`)

# -------------------- Exports --------------------
export EDITOR="nvim"
export VISUAL="nvim"



# -------------------- Configuration --------------------
# general configurations (alot of these are set by oh-my-zsh)
setopt GLOBDOTS
setopt PUSHD_SILENT
unsetopt BEEP

# ----- styling configurations (general) [for info (CTRL-X + H)]
# enable expansion of alias on tab (completer), similar to pressing (CTRL-X + A)
zstyle ':completion:*' completer _expand_alias _complete _ignored

# make ssh/scp/etc. <tab>-completion easier when using the .ssh config file/etc.
zstyle ":completion:*:(ssh|scp|ftp|sftp):*" hosts $hosts
zstyle ":completion:*:(ssh|scp|ftp|sftp):*" users $users



# -------------------- Plugins --------------------
source ~/.antigen/antigen.zsh

antigen use oh-my-zsh

# Load oh-my-zsh plugins
antigen bundle docker
antigen bundle extract
antigen bundle sudo
antigen bundle z

# Load other plugins
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
alias clip="xclip -sel clip"
alias dev="cd $HOME/Development"
alias ll="LC_COLLATE=C ls -alF --color=auto --group-directories-first"
alias npmplease="rm -rf node_modules/ && rm -f package-lock.json && npm install"
alias open="xdg-open"
# this is needed because most servers do not have kitty config yet so it would break the colors & some keys on a server
alias ssh="TERM=xterm-256color ssh"
alias vi="vim"
alias vim="nvim"

# partial aliases, which are used to be expanded and added onto afterwards
# expansion can be done manually with (CTRL-X + A) or with the completer (TAB)
alias DE="docker exec -i -t"
alias DC="docker compose"
alias GC="git checkout"



# -------------------- Special --------------------
# enable completions
# compinit needs to be run, because plugins like docker have files that are not
# in the .zcompdump and so not loaded unless compinit is run (-C does not work)
autoload -Uz compinit && compinit -i
