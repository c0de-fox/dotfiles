#!/usr/bin/env zsh
# Modified from https://github.com/robbyrussell/oh-my-zsh/blob/master/tools/check_for_upgrade.sh
# Original Copyright: (c) 2009-2018 Robby Russell and contributors
# Modified Copyright: (c) 2018 David Todd (c0de)
# License: MIT

zmodload zsh/datetime

function _current_epoch() {
  echo $(( $EPOCHSECONDS / 60 / 60 / 24 ))
}

function _touch_dotfiles_update() {
  echo "export LAST_EPOCH=$(_current_epoch)" > ${HOME}/.dotfiles-update
  echo "touched ~/.dotfiles-update"
}

function _upgrade_dotfiles() {
  env _DOTFILES=$_DOTFILES sh $_DOTFILES/upgrade.sh
  _touch_dotfiles_update
}

# Configure this in shell/env
epoch_target=$UPDATE_DOTFILES_DAYS
if [[ -z "$epoch_target" ]]; then
  # Default to every 2 weeks
  epoch_target=13
fi

# Cancel upgrade if the current user doesn't have
# write permissions for the dotfiles directory.
if [[ -w "$_DOTFILES" ]]; then
else
  echo "You can't write to $(_dotfiles)!"
  return 1
fi

# Cancel upgrade if git is unavailable on the system
if [[ $(whence git >/dev/null) || false ]]; then
else
  echo "git is not available"
  return 2
fi

if mkdir -p "$_DOTFILES/update.lock" 2>/dev/null; then
  if [ -f ${HOME}/.dotfiles-update ]; then
    . ${HOME}/.dotfiles-update

    if [[ -z "$LAST_EPOCH" ]]; then
      echo "Missing \$LAST_EPOCH"
      _touch_dotfiles_update && return 0;
    fi

    epoch_diff=$(($(_current_epoch) - $LAST_EPOCH))
    if [ $epoch_diff -gt $epoch_target ]; then
      if [ "${DISABLE_UPDATE_PROMPT}" ]; then
        _upgrade_dotfiles
      else
        echo "[Dotfiles] Would you like to check for updates? [Y/n]: \c"
        read line
        if [[ "$line" == Y* ]] || [[ "$line" == y* ]] || [ -z "$line" ]; then
          _upgrade_dotfiles
        else
          _touch_dotfiles_update
        fi
      fi
    fi
  else
    echo "Missing ~/.dotfiles-update"
    # create the zsh file
    _touch_dotfiles_update
  fi

  rmdir $_DOTFILES/update.lock
fi
