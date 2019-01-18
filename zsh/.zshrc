# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/Users/collierl/.oh-my-zsh

# Set's the zsh theme to agnoster
export TERM='screen-256color'

# Elite hackor vim mode
bindkey -v

# Sources zsh
source $ZSH/oh-my-zsh.sh

# Add's auto suggestions and auto jump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# Set the default edtior
export EDITOR="nvim"

# Set maven home
export M2_HOME="/Users/collierl"

# Cargo path
export PATH="$HOME/.cargo/bin:$PATH"

# Fuzzy search
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# tabtab source for yarn package
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-autosuggestions"

# Supports oh-my-zsh plugins and the like
zplug 'LukeCollier/zsh-theme', as:theme
zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/osx",   from:oh-my-zsh
zplug "plugins/zsh-256color",   from:oh-my-zsh
zplug "g-plane/zsh-yarn-autocompletions", hook-build:"./zplug.zsh", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load # --verbose

ZSH_THEME="collier"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

