#!/bin/bash
# Exports all installed packages to pacman.lst. One for official
# packages, and another for any packages that come from AUR.

# This can be used as a reference, or to reinstall packages with:
# `pacman -S --needed --noconfirm $(cat pacman.lst) and`
# `yay -S --needed --noconfirm $(cat pacman_aur.lst)`
# (assuming yay is your AUR helper)

pacman -Qqe | grep -v "$(pacman -Qqm)" > pacman.lst
pacman -Qqm > pacman_aur.lst
