#!/bin/bash
notify-send \
        -a "System Updates" \
        -i /home/dulsara/.config/hypr/scripts/update.png \
        "Updating info..." \
        "Wait a second plz..."

updates=$(checkupdates)

[ -z "$updates" ] && exit 0

count=$(printf '%s\n' "$updates" | wc -l)

packages=$(pacman -Quq)

total=$(printf '%s\n' "$packages" |
        xargs -r expac -S '%k' |
        awk '{sum += $1} END {print sum}')

size=$(numfmt --to=iec-i --suffix=B "$total")

notify-send \
        -a "System Updates" \
        -i /home/dulsara/.config/hypr/scripts/update.png \
        -u critical \
        "System Updates" \
        "$count packages available • $size download"