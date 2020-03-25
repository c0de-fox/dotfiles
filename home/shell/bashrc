# Include our shared environment stuff
source ~/dotfiles/home/shell/env
source ~/dotfiles/home/shell/aliases
source ~/dotfiles/home/shell/functions

# Basic options
export HISTCONTROL=ignoredups
export COLORFGBG='default;default'

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

shopt -s checkwinsize
eval "$(dircolors -b /etc/dircolors)"


# X Terminal titles
case "$TERM" in
xterm*|rxvt*)
	PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
	;;
*)
	;;
esac


# Bash completion
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

echo "appending a '&' on the back of commands will run them in the background"
echo "Don't forget ^s to pause commands and ^q to resume paused commands"

function timer_start {
  timer=${timer:-$SECONDS}
}

function timer_stop {
  timer_show=$(($SECONDS - $timer))
  unset timer
}

trap 'timer_start' DEBUG
PROMPT_COMMAND=timer_stop

# Prompt
#  Black       0;30     Dark Gray     1;30
#  Blue        0;34     Light Blue    1;34
#  Green       0;32     Light Green   1;32
#  Cyan        0;36     Light Cyan    1;36
#  Red         0;31     Light Red     1;31
#  Purple      0;35     Light Purple  1;35
#  Brown       0;33     Yellow        1;33
#  Light Gray  0;37     White         1;37

BLACK='\[\033[0;30m\]'
BLUE='\[\033[0;34m\]'
GREEN='\[\033[0;32m\]'
CYAN='\[\033[0;36m\]'
RED='\[\033[0;31m\]'
PURPLE='\[\033[0;35m\]'
BROWN='\[\033[0;33m\]'
LGRAY='\[\033[0;37m\]'
DGRAY='\[\033[1;30m\]'
LBLUE='\[\033[1;34m\]'
LGREEN='\[\033[1;32m\]'
LCYAN='\[\033[1;36m\]'
LRED='\[\033[1;31m\]'
LPURPLE='\[\033[1;35m\]'
YELLOW='\[\033[1;33m\]'
WHITE='\[\033[1;37m\]'

RBG='\e[41m'
ALERT=${WHITE}${RBG} # Bold White on red background
NC="\e[m"               # Color Reset

PS1="\[\033]0;Bash | \u@\H:\w\007\]" # Add a dynamically changing window title - Shows current user@host:current directory (comment this and "$PS1" at beginning of next line when not an a terminal emulator)
PS1="$PS1""${LGREEN}[${LPURPLE}\u${WHITE}@${LBLUE}\h${LGREEN}]-(${YELLOW}\w${LGREEN})"
PS1="$PS1""\n  [${LRED}\@ ${LGRAY}Last:${WHITE} \${timer_show}s ${LCYAN}Err:"

# Error code test - not working
#if [[ \$? = "0" ]] # If last program exited with 0 (good exit)
#then
	PS1="$PS1"" ${WHITE}\$?" # show white error code
#else
#	PS1="$PS1"" ${LRED}\$?" # if last program exited with anything else, show red error code
#fi

PS1="$PS1"" ${LPURPLE}BJobs:${PURPLE} \j ${LBLUE}Hist: ${LCYAN}\!${LGREEN}]\n  ->${LGRAY} "
#PS1="$PS1"" ${NC}"
