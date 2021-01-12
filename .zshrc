# Include our shared environment stuff
source ~/.environment
source ~/.aliases
source ~/.functions

# History Settings
export HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd ..:cd..:replay"
export HISTSIZE=25000
export HISTFILE=~/.zsh_history
export SAVEHIST=10000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Say how long a command took, if it took more than 5 seconds
export REPORTTIME=5

# Prompts for confirmation after 'rm *' etc
# Helps avoid mistakes like 'rm * o' when 'rm *.o' was intended
setopt RM_STAR_WAIT

# Background processes aren't killed on exit of shell
setopt AUTO_CONTINUE

# Don’t write over existing files with >, use >! instead
setopt NOCLOBBER

# Don’t nice background processes
setopt NO_BG_NICE

# Makes Alt-s insert a sudo at beginning of prompt
function insert_sudo {
    if [[ $BUFFER != "sudo "* ]]; then
        BUFFER="sudo $BUFFER"; CURSOR+=6
    fi
}
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

# Check for updates...
# Stolen and modified Oh-My-ZSH's update system
if [ "${ENABLE_DOTFILES_AUTO_UPDATE}" ]; then
  env ZSH=$ZSH _DOTFILES=$_DOTFILES DISABLE_UPDATE_PROMPT=$DISABLE_DOTFILES_UPDATE_PROMPT zsh -f $_DOTFILES/check_for_upgrade.sh
fi

# Oh-My-ZSH Options below this line

# Define Oh-My-ZSH root
ZSH=$HOME/.oh-my-zsh

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$_DOTFILES/omz

# Theme for Oh-My-ZSH
ZSH_THEME="darkblood"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git \
    catimg \
    fancy-ctrl-z \
    emoji \
    aws \
    jsontools \
    zsh-syntax-highlighting) # zsh-syntax-highlighting must remain the last plugin

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh
