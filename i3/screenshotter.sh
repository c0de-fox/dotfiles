#!/bin/bash

# Simple screenshot uploader
# The web server is nginx and configured with h5ai to be a file manager
# Copyright (c) 2019 David Todd (c0de) c0de@c0defox.es

DATE=$(date +%Y-%m-%d-%s).png
FILENAME=~/Pictures/$DATE

maim -s $FILENAME&
wait $!

notify-send "Uploading Screenshot"
scp $FILENAME web.foxnet.space:/var/www/c0de.link/pics&
wait $!

echo https://i.c0de.link/$DATE | xclip -selection clipboard
notify-send "Link copied to Clipboard"
