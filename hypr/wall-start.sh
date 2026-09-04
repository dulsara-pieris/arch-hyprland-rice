#!/usr/bin/env bash

STATE_FILE="$HOME/.config/awww/current-wallpaper"

awww-daemon &

sleep 1

if [[ -f "$STATE_FILE" ]] && [[ -f "$(cat "$STATE_FILE")" ]]; then
        awww img "$(cat "$STATE_FILE")"
else
        awww img "$HOME/Pictures/Wallpapers/201532.jpg"
fi