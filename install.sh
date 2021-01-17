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
DF_HOME=${DOTFILES}/home
DF_CONFIG=${DF_HOME}/.config
POSTINSTALL_SCRIPT=${HOME}/.dotfiles.postinst

if [ ! -e "${POSTINSTALL_SCRIPT}" ]; then
    echo "No post install script found."
    echo "Optionally create one at ${POSTINSTALL_SCRIPT} and rerun this script"
fi

# Attempts to safely install the configs as symlinks (backing up existing ones)
function symlink() {
    src=$1
    dest=$2

    if [ -e "${dest}" ]; then
        if [ -L "${dest}" ]; then
            # Already symlinked -- I'll assume correctly.
            return
        else
            # Rename files with a ".old" extension.
            echo "${dest} already exists, renaming to ${dest}.old"
            backup="${dest}.old"
            if [ -e "${backup}" ]; then
                echo "Error: $backup already exists. Please delete or rename it."
                exit 1
            fi
            mv -v "${dest}" "${backup}"
        fi
    fi
    echo "Linking $(basename "${src}")..."
    ln -sf "${src}" "${dest}"
}

read -p "Press enter to install dotfiles " WAIT_FOR_INPUT

# If the update script exists, try to do a normal update
if [ -x "${DOTFILES}/check_for_upgrade.sh" ]; then
    source "${DF_HOME}/.environment"
    env _DOTFILES="${DOTFILES}" DISABLE_UPDATE_PROMPT=false zsh -f "${DOTFILES}/check_for_upgrade.sh"
else
    echo "Cloning to ${DOTFILES}"
    rm -rf "${DOTFILES}"
    git clone --recurse-submodules -j$(nproc) "${GIT_REPO}" "${DOTFILES}"
fi

echo "Installing user binary directory to ~/bin"
symlink "${DF_HOME}/bin" "${HOME}/bin"

echo "Creating needed directories"
mkdir -p "${HOME}/.tmux"
mkdir -p "${HOME}/.vim/{autoload,bundle}"

echo "Linking Configuration files..."

# All the dotfiles that live in the home dir directly
symlink "${DOTFILES}/.editorconfig"             "${HOME}/.editorconfig"
symlink "${DF_HOME}/.aliases"                   "${HOME}/.aliases"
symlink "${DF_HOME}/.bashrc"                    "${HOME}/.bashrc"
symlink "${DF_HOME}/.dmenurc"                   "${HOME}/.dmenurc"
symlink "${DF_HOME}/.dmrc"                      "${HOME}/.dmrc"
symlink "${DF_HOME}/.environment"               "${HOME}/.environment"
symlink "${DF_HOME}/.functions"                 "${HOME}/.functions"
symlink "${DF_HOME}/.gitconfig"                 "${HOME}/.gitconfig"
symlink "${DF_HOME}/.stalonetrayrc"             "${HOME}/.stalonetrayrc"
symlink "${DF_HOME}/.tmux.conf"                 "${HOME}/.tmux.conf"
symlink "${DF_HOME}/.tmux/iceberg.tmux.conf"    "${HOME}/.tmux/iceberg.tmux.conf"
symlink "${DF_HOME}/.vimrc"                     "${HOME}/.vimrc"
symlink "${DF_HOME}/.zshrc"                     "${HOME}/.zshrc"

# Install ~/.config stuff
symlink "${DF_CONFIG}/.rofi"                    "${HOME}/.config/.rofi"
symlink "${DF_CONFIG}/compton"                  "${HOME}/.config/compton"
symlink "${DF_CONFIG}/dunst"                    "${HOME}/.config/dunst"
symlink "${DF_CONFIG}/gtk-2.0"                  "${HOME}/.config/gtk-2.0"
symlink "${DF_CONFIG}/gtk-3.0"                  "${HOME}/.config/gtk-3.0"
symlink "${DF_CONFIG}/htop"                     "${HOME}/.config/htop"
symlink "${DF_CONFIG}/i3"                       "${HOME}/.config/i3"
symlink "${DF_CONFIG}/morc_menu"                "${HOME}/.config/morc_menu"
symlink "${DF_CONFIG}/nitrogen"                 "${HOME}/.config/nitrogen"
symlink "${DF_CONFIG}/terminator"               "${HOME}/.config/terminator"
symlink "${DF_CONFIG}/ranger"                   "${HOME}/.config/ranger"
symlink "${DF_CONFIG}/viewnior"                 "${HOME}/.config/viewnior"
symlink "${DF_CONFIG}/volumeicon"               "${HOME}/.config/volumeicon"
symlink "${DF_CONFIG}/mimeapps.list"            "${HOME}/.config/mimeapps.list"
symlink "${DF_CONFIG}/Code/User/settings.json"  "${HOME}/.config/Code/User/settings.json"

echo "Installing Iceberg GTK theme and Icon pack..."
symlink "${DF_HOME}/.themes/oomox-iceberg" "${HOME}/.themes/oomox-iceberg"
symlink "${DF_HOME}/.icons/oomox-iceberg"  "${HOME}/.icons/oomox-iceberg"

echo "Building i3 configuration..."
"${DF_HOME}/bin/build-i3-config"

echo "Changing default shell to ZSH..."
chsh -s /usr/bin/zsh

echo "Installing Oh-My-ZSH..."
CHSH='no' RUNZSH='no' KEEP_ZSHRC='yes' sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#echo "Installing VSCode Extensions..."
#cat "${DOTFILES}/vs_code_extensions.lst" | xargs -n 1 code --install-extension --force

echo "Installing VIM Pathogen..."
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
