#!/usr/bin/env bash

sid=$1

# Check if workspace has windows
apps=$(/opt/homebrew/bin/aerospace list-windows --workspace "$sid")

if [ -z "$apps" ]; then
    # Workspace is empty → hide (unless it's the focused one)
    if [ "$sid" = "$FOCUSED_WORKSPACE" ]; then
        sketchybar --set space.$sid drawing=on background.drawing=on
    else
        sketchybar --set space.$sid drawing=off
    fi
else
    # Workspace has windows → show
    sketchybar --set space.$sid drawing=on

    # Highlight if focused
    if [ "$sid" = "$FOCUSED_WORKSPACE" ]; then
        sketchybar --set space.$sid background.drawing=on
    else
        sketchybar --set space.$sid background.drawing=off
    fi
fi
