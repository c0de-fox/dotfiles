#!/usr/bin/env bash

# This ensures that the entire script is downloaded before execution
{

# Change this url to point to your repo if you made customizations
repourl="git://github.com/alopexc0de/dotfiles.git"

# Exit the script if any errors are encountered
#set -e

basedir=$HOME/dotfiles
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
if [ -x "$basedir/internal_bin/check_for_upgrade.sh" ]; then
    source "$basedir/shell/env"
    env _DOTFILES=$basedir DISABLE_UPDATE_PROMPT='FALSE' zsh -f $basedir/internal_bin/check_for_upgrade.sh
else
    echo "Cloning dotfiles to $basedir"
    rm -rf $basedir
    git clone --depth=1 $repourl $basedir
fi

# Start installing config

echo "Linking config and local files"
# Environment
symlink $basedir/home/.local $HOME/.local
symlink $basedir/home/.config $HOME/.config

echo "Installing Oh-My-ZSH"
echo "When the install is done, type \"exit\" to continue installing dotfiles"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Building i3 configuration"
$basedir/bin/build-i3-config

echo "Linking X-Session files"
# Stuff related to the X-Session
symlink $basedir/home/.config/compton.conf $HOME/.compton.conf
symlink $basedir/home/Xresources $HOME/.Xresources
symlink $basedir/home/xinitrc $HOME/.xinitrc

echo "Linking shell files"
# Shell stuff
symlink $basedir/home/shell/tmux.conf $HOME/.tmux.conf
symlink $basedir/home/shell/bashrc $HOME/.bashrc
symlink $basedir/home/shell/zshrc $HOME/.zshrc
symlink $basedir/home/shell/vimrc $HOME/.vimrc
symlink $basedir/home/dmenurc $HOME/.dmenurc
symlink $basedir/home/dmrc $HOME/.dmrc

# Global git
symlink $basedir/home/gitconfig $HOME/.gitconfig

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
mkdir -p $bindir
for file_path in $basedir/bin/*; do
    symlink $file_path $bindir/$(basename $file_path)
done

echo "Changing default shell to ZSH..."
chsh -s /usr/bin/zsh

if [ -e "$postinst" ]; then
    echo "Running post install..."
    source "$postinst"
else
    echo "No post install script found. Optionally create one at $postinst and reinstall your dotfies"
fi

echo "Install done."
echo "Check tmux, vim, and your shell to verify everything is correct"
echo "you may need to launch a new instance of your shell"

} # Ensures that the whole script is downloaded before execution
