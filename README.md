# Dotfiles!

## Installation

1. Optionally create ~/.dotfiles.postinst
2. `bash <(curl -sL http://lob.li/itt)` (https://raw.githubusercontent.com/alopexc0de/dotfiles/master/install.sh)
3. ????
4. Profit

## Dotfiles Postinstall
You may create a standard text file called `.dotfiles.postinst` in your home directory before installing.
This file contains commands, one per line, that will be executed in order after the install script finishes.
For example, you may want to add commands such as `git config --global user.name "My Name"` and `git config --global user.email "me@my.email"`

## Customizing Dotfiles
1. Fork this repo
2. Update `repourl` inside install.sh to point to your own
3. Make your changes
4. Push to origin
5. Install your new dotfiles everywhere

## i3 information
My dotfiles now include my personalized i3 configuration if you also run the i3wm.

* [i3-gaps](https://github.com/Airblader/i3) WM
* [i3blocks](https://github.com/vivien/i3blocks) i3bar scheduler
* [i3lock-fancy](https://github.com/meskarune/i3lock-fancy) locker
* [rofi](https://github.com/DaveDavenport/rofi) launcher
* [Adobe's Source Code Pro](https://github.com/adobe-fonts/source-code-pro) font
* [terminator](https://wiki.archlinux.org/index.php/Terminator) terminal
* [feh](https://feh.finalrewind.org/) Image viewer/wallpaper
* [xcompmgr](https://wiki.archlinux.org/index.php/Xcompmgr) Compisiton Manager (window transparency)

## Branch Info

This is the primary branch.
It includes changes that should be included in most, if not
all of the different configurations that may result of different 
system use. 

For now, there is the master and macos
The macos branch is mostly athestic changes and plugins chosen
for my macbook. 
