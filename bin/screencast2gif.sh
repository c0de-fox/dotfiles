#!/bin/bash

date=$(date +%Y-%m-%d-%s)

ffmpeg() {
    command ffmpeg -hide_banner -loglevel error -nostdin "$@"
}

ffcast -q $(while slop -q -n -f '-g %g ';do :;done) rec ~/Videos/screencast-${date}.mp4

ffmpeg -i ~/Videos/screencast-${date}.mp4 -vf palettegen -f image2 -c:v png - |
    ffmpeg -i ~/Videos/screencast-${date}.mp4 -i - -filter_complex paletteuse ~/Pictures/screencast-${date}.gif && notify-send "Gif recorded to ~/Pictures/screencast-${date}"
