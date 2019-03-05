#!/bin/bash

DATE=$(date +%Y-%m-%d-%s).png
FILENAME=~/Pictures/$DATE

maim -s $FILENAME&
wait $!

notify-send "Uploading Screenshot"
scp $FILENAME web.foxnet.space:/var/www/c0de.link/pics&
wait $!

echo https://i.c0de.link/$DATE | xclip -selection clipboard
notify-send "Link copied to Clipboard"
