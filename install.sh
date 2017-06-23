#!/bin/bash

# This file will attempt to automatically configure and install my dotfiles
# This assumes that the following are already installed and in the PATH; perhaps we will attempt to auto-install them in the future
# tmux
# vim
# zsh
# curl
# git
# php 5.3 or greater

# First things first, install oh-my-zsh
echo "Installing Oh-My-ZSH"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Overriding ~/.zshrc. A backup can be found at ~/.zshrc.backup"
mv ~/.zshrc ~/.zshrc.backup
ln -s ~/dotfiles/shell/zshrc ~/.zshrc

echo "Overriding ~/.bashrc. A backup can be found at ~/.bashrc.backup"
mv ~/.bashrc ~/.bashrc.backup
ln -s ~/dotfiles/shell/bashrc ~/.bashrc

echo "Installing tmux config"
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf

echo "Installing VIM Pathogen"
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

echo "Installing VIM Sensible"
cd ~/.vim/bundle
git clone git://github.com/tpope/vim-sensible.git

echo "Installing VIM config"
ln -s ~/dotfiles/vimrc ~/.vimrc

echo "Changing default shell to ZSH"
chsh -s /usr/bin/zsh

# Check for ~/bin and create it if it doesn't exist
if [[ !-d ~/bin ]]; then
    mkdir -p ~/bin
fi

# Check for secret ~/dotfiles/.bin and create it if it doesn't exist
if [[ !-d ~/dotfiles/.bin ]]; then
    mkdir -p ~/dotfiles/.bin
fi

# Install wp-cli
echo "Installing wp-cli"
cd ~/dotfiles/.bin
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod a+x wp-cli.phar
ln -s ~/dotfiles/.bin/wp-cli.phar ~/bin/wp

# Since $HOME/bin is in the PATH, this should work
wp --info

echo "Install done."
echo "Check tmux, vim, and your shell to verify everything is correct"
echo "you may need to launch a new instance of your shell"
