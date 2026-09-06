#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
STATE_FILE="$HOME/.config/awww/current-wallpaper"
ROFI_THEME="$HOME/.config/rofi/background.rasi"

mkdir -p "$(dirname "$STATE_FILE")"

# Build wallpaper list with thumbnails
SELECTED="$(
        find "$WALLPAPER_DIR" -maxdepth 1 -type f \
                \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) |
        sort |
        while IFS= read -r file; do
                printf '%s\0icon\x1f%s\n' \
                        "$(basename "$file")" \
                        "$file"
        done |
        rofi \
                -dmenu \
                -i \
                -show-icons \
                -format s \
                -theme "$ROFI_THEME" \
                -p ""
)"

# Nothing selected
[[ -z "$SELECTED" ]] && exit 0

WALLPAPER="$WALLPAPER_DIR/$SELECTED"

# Make sure the selected file exists
if [[ ! -f "$WALLPAPER" ]]; then
        notify-send "Wallpaper Error" "File not found: $SELECTED"
        exit 1
fi

# Make sure awww is running
if ! pgrep -x awww-daemon >/dev/null; then
        awww-daemon &
        sleep 1
fi

MOUSE_POS="$(hyprctl cursorpos)"

if awww img "$WALLPAPER" \
        --transition-type grow \
        --transition-pos "$MOUSE_POS" \
        --transition-duration 1 \
        --transition-fps 60 \
        --transition-step 3; then

        printf '%s\n' "$WALLPAPER" > "$STATE_FILE"

else
        notify-send "Wallpaper Error" "awww failed to change the wallpaper"
        exit 1
fi