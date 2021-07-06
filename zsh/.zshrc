
# Local bin on path
export PATH=/Users/lukecollier/.local/bin:$PATH

# terminal prompt
eval "$(starship init zsh)"

# Autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# Vi mode
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey -v
export KEYTIMEOUT=1

# Vi mode
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt SHARE_HISTORY

export VISUAL=nvim
export EDITOR=nvim

export DOCKER_OPTS="${DOCKER_OPTS} --insecure-registry weaponx-docker.artifactory.us-east-1.bamgrid.net"

# file browser setup
export NNN_PLUG='o:fzopen;d:diffs;n:notes;j:autojump'

alias nnn="nnn -E"
alias ls="lsd"
alias utcdate='date -u +"%Y-%m-%dT%H:%M:%SZ"'

eval "`fnm env`"

# # Feed the output of fd into fzf
# fd --type f | fzf

# Setting fd as the default source for fzf
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --color=always'
export FZF_DEFAULT_OPTS="--ansi"

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Start tmux if it's not already running
if [ "$TMUX" = "" ]; then tmux; fi
