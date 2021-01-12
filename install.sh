#!/usr/bin/env bash

# This ensures that the entire script is downloaded before execution
{

# Change this url to point to your repo if you made customizations
repourl="git://github.com/alopexc0de/dotfiles.git"

# Exit the script if any errors are encountered
#set -e

DOT_DIR=$HOME/dotfiles
bindir=$HOME/bin
postinst=$HOME/.dotfiles.postinst

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

read -p "Press enter to install my dotfiles " WAIT_FOR_INPUT

if ! which git >>/dev/null ; then
  echo "Error: git is not installed"
  exit 1
fi

# If the update script exists, try to do a normal update
if [ -x "$DOT_DIR/internal_bin/check_for_upgrade.sh" ]; then
    source "$DOT_DIR/shell/env"
    env _DOTFILES=$DOT_DIR DISABLE_UPDATE_PROMPT='FALSE' zsh -f $DOT_DIR/internal_bin/check_for_upgrade.sh
else
    echo "Cloning dotfiles to $DOT_DIR"
    rm -rf "${DOT_DIR}"
    git clone --depth=1 $repourl $DOT_DIR
fi

# Start installing config

echo "Linking config and local files"
# Environment
symlink $DOT_DIR/home/.local $HOME/.local
symlink $DOT_DIR/home/.config $HOME/.config

echo "Installing Oh-My-ZSH"
echo "When the install is done, type \"exit\" to continue installing dotfiles"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Building i3 configuration"
$DOT_DIR/bin/build-i3-config

echo "Linking X-Session files"
# Stuff related to the X-Session
symlink $DOT_DIR/home/.config/compton.conf $HOME/.compton.conf
symlink $DOT_DIR/home/Xresources $HOME/.Xresources
symlink $DOT_DIR/home/xinitrc $HOME/.xinitrc

echo "Linking shell files"
# Shell stuff
symlink $DOT_DIR/home/shell/tmux.conf $HOME/.tmux.conf
symlink $DOT_DIR/home/shell/bashrc $HOME/.bashrc
symlink $DOT_DIR/home/shell/zshrc $HOME/.zshrc
symlink $DOT_DIR/home/shell/vimrc $HOME/.vimrc
symlink $DOT_DIR/home/dmenurc $HOME/.dmenurc
symlink $DOT_DIR/home/dmrc $HOME/.dmrc

# Global git
symlink $DOT_DIR/home/gitconfig $HOME/.gitconfig

echo "Installing shell-history"
python3 -m pip install shellhistory

echo "Installing VIM Pathogen..."
mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle
curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

echo "Installing VIM Sensible..."
cd $HOME/.vim/bundle
git clone git://github.com/tpope/vim-sensible.git

echo "Installing VIM Iceberg theme"
cd /tmp
wget https://www.vim.org/scripts/download_script.php?src_id=25718 -O iceberg.zip
unzip iceberg.zip
cp -r iceberg.vim/{autoload,colors} ~/.vim/

echo "Adding user bin..."
symlink $DOT_DIR/bin $HOME/bin

echo "Changing default shell to ZSH..."
chsh -s /usr/bin/zsh

if [ -e "$postinst" ]; then
    echo "Running post install..."
    source "$postinst"
else
    echo "No post install script found. Optionally create one at $postinst and reinstall your dotfies"
fi

echo "Install done."
echo "Log out and back in again for everything to take effect."

} # Ensures that the whole script is downloaded before execution
