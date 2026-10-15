#!/bin/bash

CLASS="music-scratchpad"
WORKSPACE="special:music"

# Does the music window already exist?
if hyprctl clients -j | jq -e \
        ".[] | select(.class == \"$CLASS\")" >/dev/null; then

        # Already exists → show/hide scratchpad
        hyprctl dispatch togglespecialworkspace music
        exit 0
fi

# Create the music TUI
kitty \
        --class "$CLASS" \
        --title "♥ Music" \
        -o background_opacity=0.93 \
        -e ncmpcpp &

# Wait until the window actually exists
while ! hyprctl clients -j | jq -e \
        ".[] | select(.class == \"$CLASS\")" >/dev/null; do
        sleep 0.05
done

# Move it to the special workspace
hyprctl dispatch movetoworkspacesilent "$WORKSPACE"

# Show the scratchpad
hyprctl dispatch togglespecialworkspace music