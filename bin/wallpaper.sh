#!/bin/bash
shopt -s nullglob

#===change these config start===

#wallpapers directory path
path=~/Pictures/Wallpapers

#time interval
interval=5m

#===change these config end===

cd $path

while true; do
	files=()

	for i in *.jpg *.png; do
		[[ -f $i ]] && files+=("$i")
	done
	range=${#files[@]}

	((range)) && feh --bg-scale "${files[RANDOM % range]}"

	sleep $interval
done
