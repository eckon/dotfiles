# -------------------- Exports --------------------
export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"



# -------------------- Configuration --------------------
unsetopt BEEP
HYPHEN_INSENSITIVE="true"

# make ssh/scp/etc. <tab>-completion easier when using the .ssh config file/etc.
zstyle ':completion:*:(ssh|scp|ftp|sftp):*' hosts $hosts
zstyle ':completion:*:(ssh|scp|ftp|sftp):*' users $users



# -------------------- Plugins --------------------
source ~/.antigen/antigen.zsh

antigen use oh-my-zsh

# Load oh-my-zsh plugins
antigen bundle z

# Load other plugins
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

antigen theme romkatv/powerlevel10k

antigen apply



# -------------------- Source --------------------
# enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# unset aliases from oh-my-zsh plugins
# I mainly want to use them for autocompletion and functionaliy not aliases
unalias -a

# use for fzf app
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# to customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# source rust
[ -f ~/.cargo/env ] && source ~/.cargo/env



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

# use to init some plugins (docker, docker-compose, git, probably others as well)
autoload -Uz compinit && compinit -i
