# Dotfiles!

## Installation

1. Install dependencies
1. Optionally create ~/.dotfiles.postinst
1. `bash <(curl -sL https://dotfiles.online)` (https://c0de.dev/c0de/dotfiles/raw/branch/master/install.sh)
1. ????
1. Profit

### Dependencies

I primarilarly use Arch, but these dotfiles also get installed to headless Debian servers.  
It shouldn't be difficult to find an equilivant package for your distribution with the provided lists

A list of the packages that I have installed can be found in the files `pacman.lst` and `pacman_aur.lst`.  
Non-official packages come from the AUR, which can't typically be installed by pacman directly and the reason why it's a seperate list.

Most of those packages are completely optional. The bare minimum for installing these dotfiles require you to have these programs:

1. git
1. curl
1. unzip

### Dotfiles Postinstall

You may create a standard text file called `.dotfiles.postinst` in your home directory before installing.  
This file is basically a bash script that contains commands, that will be executed after the install script finishes.  
For example, you may want to add commands such as `git config --global user.name "My Name"` and `git config --global user.email "me@my.email"`

## Customizing Dotfiles

1. Fork this repo
2. Update `repourl` inside install.sh to point to your own
3. Make your changes
4. Push to origin
5. Install your new dotfiles everywhere
