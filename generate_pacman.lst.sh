#!/bin/bash
# Exports all installed packages to pacman.lst. One for official
# packages, and another for any packages that come from AUR.

# This can be used as a reference, or to reinstall packages with:
# `cat pacman.lst | xargs pacman -S --needed --noconfirm` and
# `cat pacman_aur.lst | xargs yay -S --needed --noconfirm`
# (assuming yay is your AUR helper)

pacman -Qqe | grep -v "$(pacman -Qqm)" > pacman.lst
pacman -Qqm > pacman_aur.lst
