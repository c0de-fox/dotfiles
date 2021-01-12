#!/bin/bash
# Exports all installed packages, including foreign ones (AUR)
# This can be used as a reference, or to reinstall packages with:
# `cat pacman.lst | xargs pacman -S --needed --noconfirm`

pacman -Qqe | grep -v "$(pacman -Qqm)" > pacman.lst
