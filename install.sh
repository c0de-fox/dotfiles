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

echo "Please ensure that the following packages are installed and available in your PATH before proceeding:"
echo "tmux, vim, zsh, curl, git"

read -p "Press enter to continue. " WAIT_FOR_INPUT

if ! which git >>/dev/null ; then
  echo "Error: git is not installed"
  exit 1
fi

# If the update script exists, try to do a normal update
if [ -x "$basedir/check_for_upgrade.sh" ]; then
    source "$basedir/shell/env"
    env _DOTFILES=$basedir DISABLE_UPDATE_PROMPT='FALSE' zsh -f $basedir/check_for_upgrade.sh
else
    echo "Cloning dotfiles to $basedir"
    rm -rf $basedir
    git clone --depth=1 $repourl $basedir
fi

# Start installing config

echo "Installing Oh-My-ZSH"
echo "When the install is done, type `exit` to continue installing dotfiles"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Creating Symlinks..."
symlink $basedir/shell/zshrc $HOME/.zshrc
symlink $basedir/shell/bashrc $HOME/.bashrc
symlink $basedir/tmux.conf $HOME/.tmux.conf
symlink $basedir/vimrc $HOME/.vimrc
symlink $basedir/gitconfig $HOME/.gitconfig
symlink $basedir/Xresources $HOME/.Xresources

echo "Installing VIM Pathogen..."
mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle
curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

echo "Installing VIM Sensible..."
cd $HOME/.vim/bundle
git clone git://github.com/tpope/vim-sensible.git

echo "Adding user bin..."
mkdir -p $bindir $basedir/.bin
for path in bin/* ; do
    symlink $basedir/$path $bindir/$(basename $path)
done

echo "Changing default shell to ZSH..."
chsh -s /usr/bin/zsh

# Install i3 config
echo "Installing i3 configuration"
mkdir -p $HOME/.config/i3
mkdir -p $HOME/.i3
symlink $basedir/i3/config $HOME/.config/i3/config
symlink $basedir/i3/i3blocks.conf $HOME/.i3/i3blocks.conf
symlink $basedir/i3/wallpaper.sh $Home/.i3/wallpaper.sh

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
