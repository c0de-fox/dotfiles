# Modified from https://github.com/robbyrussell/oh-my-zsh/blob/master/tools/check_for_upgrade.sh
# Original Copyright: (c) 2009-2018 Robby Russell and contributors
# Modified Copyright: (c) 2018 David Todd (c0de)
# License: MIT

# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  BOLD="$(tput bold)"
  NORMAL="$(tput sgr0)"
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  NORMAL=""
fi

printf "${BLUE}%s${NORMAL}\n" "Updating your dotfiles"
cd "$_DOTFILES"
branch=$(git name-rev --name-only HEAD)
if git pull --rebase --stat origin $branch
then
  printf '%s' "$GREEN"
  printf '%s\n' ' _____     ______     ______   ______   __     __         ______     ______    '
  printf '%s\n' '/\  __-.  /\  __ \   /\__  _\ /\  ___\ /\ \   /\ \       /\  ___\   /\  ___\   '
  printf '%s\n' '\ \ \/\ \ \ \ \/\ \  \/_/\ \/ \ \  __\ \ \ \  \ \ \____  \ \  __\   \ \___  \  '
  printf '%s\n' ' \ \____-  \ \_____\    \ \_\  \ \_\    \ \_\  \ \_____\  \ \_____\  \/\_____\ '
  printf '%s\n' '  \/____/   \/_____/     \/_/   \/_/     \/_/   \/_____/   \/_____/   \/_____/ '
  printf "${BLUE}%s\n" "Hooray! Your dotfiles have been updated and/or is at the current version."
else
  printf "${RED}%s${NORMAL}\n" 'There was an error updating. Try again later?'
fi
cd $OLDPWD
