#!/usr/bin/env bash

# This ensures that the entire script is downloaded before execution
{

if ! which git >>/dev/null ; then
  echo "Error: git is not installed"
  exit 1
fi

# Exit the script if any errors are encountered
#set -e

# Change this url to point to your repo if you made customizations
GIT_REPO="git://github.com/alopexc0de/dotfiles.git"

DOTFILES=${HOME}/dotfiles
POSTINSTALL_SCRIPT=${HOME}/.dotfiles.postinst

if [ ! -e "${POSTINSTALL_SCRIPT}" ]; then
    echo "No post install script found."
    echo "Optionally create one at ${POSTINSTALL_SCRIPT} and rerun this script"
fi

# Attempts to safely install the configs as symlinks (backing up existing ones)
function symlink() {
    src=$1
    dest=$2

    if [ -e $dest ]; then
        if [ -L $dest ]; then
            # Already symlinked -- I'll assume correctly.
            return
        else
            # Rename files with a ".old" extension.
            echo "$dest already exists, renaming to $dest.old"
            backup=$dest.old
            if [ -e $backup ]; then
                echo "Error: $backup already exists. Please delete or rename it."
                exit 1
            fi
            mv -v $dest $backup
        fi
    fi
    echo "Linking $(basename $src)..."
    ln -sf $src $dest
}

read -p "Press enter to install dotfiles " WAIT_FOR_INPUT

# If the update script exists, try to do a normal update
if [ -x "${DOTFILES}/check_for_upgrade.sh" ]; then
    source "${DOTFILES}/shell/.environment"
    env DOTFILES="${DOTFILES}" DISABLE_UPDATE_PROMPT=false zsh -f "${DOTFILES}/check_for_upgrade.sh"
else
    echo "Cloning to ${DOTFILES}"
    rm -rf "${DOTFILES}"
    git clone --recurse-submodules -j$(nproc) "${GIT_REPO}" "${DOTFILES}"
fi

echo "Installing user binary directory to ~/bin"
symlink "${DOTFILES}/bin" "${HOME}/bin"

echo "Linking Configuration files..."

# All the dotfiles that live in the home dir directly
symlink "${DOTFILES}/shell/.aliases"          "${HOME}/.aliases"
symlink "${DOTFILES}/shell/.bashrc"           "${HOME}/.bashrc"
symlink "${DOTFILES}/shell/.dmenurc"          "${HOME}/.dmenurc"
symlink "${DOTFILES}/shell/.dmrc"             "${HOME}/.dmrc"
symlink "${DOTFILES}/shell/.editorconfig"     "${HOME}/.editorconfig"
symlink "${DOTFILES}/shell/.environment"      "${HOME}/.environment"
symlink "${DOTFILES}/shell/.functions"        "${HOME}/.functions"
symlink "${DOTFILES}/shell/.gitconfig"        "${HOME}/.gitconfig"
symlink "${DOTFILES}/shell/.stalonetrayrc"    "${HOME}/.stalonetrayrc"
symlink "${DOTFILES}/shell/.tmux.conf"        "${HOME}/.tmux.conf"
symlink "${DOTFILES}/shell/.vimrc"            "${HOME}/.vimrc"
symlink "${DOTFILES}/shell/.zshrc"            "${HOME}/.zshrc"

# Install ~/.config stuff
symlink "${DOTFILES}/.config/.rofi"           "${HOME}/.config/.rofi"
symlink "${DOTFILES}/.config/compton"         "${HOME}/.config/compton"
symlink "${DOTFILES}/.config/dunst"           "${HOME}/.config/dunst"
symlink "${DOTFILES}/.config/gtk-2.0"         "${HOME}/.config/gtk-2.0"
symlink "${DOTFILES}/.config/gtk-3.0"         "${HOME}/.config/gtk-3.0"
symlink "${DOTFILES}/.config/htop"            "${HOME}/.config/htop"
symlink "${DOTFILES}/.config/i3"              "${HOME}/.config/i3"
symlink "${DOTFILES}/.config/morc_menu"       "${HOME}/.config/morc_menu"
symlink "${DOTFILES}/.config/nitrogen"        "${HOME}/.config/nitrogen"
symlink "${DOTFILES}/.config/terminator"      "${HOME}/.config/terminator"
symlink "${DOTFILES}/.config/ranger"          "${HOME}/.config/ranger"
symlink "${DOTFILES}/.config/viewnior"        "${HOME}/.config/viewnior"
symlink "${DOTFILES}/.config/volumeicon"      "${HOME}/.config/volumeicon"
symlink "${DOTFILES}/.config/mimeapps.list"   "${HOME}/.config/mimeapps.list"

echo "Building i3 configuration..."
"${DOTFILES}/bin/build-i3-config"

echo "Changing default shell to ZSH..."
chsh -s /usr/bin/zsh

echo "Installing Oh-My-ZSH..."
CHSH='no' RUNZSH='no' KEEP_ZSHRC='yes' sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Installing VIM Pathogen..."
mkdir -p "${HOME}/.vim/{autoload,bundle}"
curl -LSs https://tpo.pe/pathogen.vim -o "${HOME}/.vim/autoload/pathogen.vim"

echo "Installing VIM Sensible..."
git clone git://github.com/tpope/vim-sensible.git "${HOME}/.vim/bundle/vim-sensible"

echo "Installing VIM Iceberg theme..."
cd /tmp
wget https://www.vim.org/scripts/download_script.php?src_id=25718 -O iceberg.zip
unzip iceberg.zip
cp -r iceberg.vim/{autoload,colors} "${HOME}/.vim/"
rm -rf /tmp/iceberg*
cd "${HOME}"

if [ -e "${POSTINSTALL_SCRIPT}" ]; then
    echo "Running post install..."
    "${POSTINSTALL_SCRIPT}"
fi

echo "Install done."
echo "Log out and back in again for everything to take effect."

} # Ensures that the whole script is downloaded before execution
