#!/bin/bash

# Define the directory containing the wallpapers
WALLPAPER_DIR="$HOME/Pictures/Wallpapers/"

# Make sure we can connect to the desktop environment
export DISPLAY=":0"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

# Select a random wallpaper from the directory
SELECTED_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Determine the current color scheme to decide which property to set
COLOR_SCHEME=$(gsettings get org.gnome.desktop.interface color-scheme)

# Change the wallpaper based on the color scheme
if [ "$COLOR_SCHEME" = "'prefer-dark'" ]; then
    # Set the wallpaper for dark theme
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$SELECTED_WALLPAPER"
else
    # Set the wallpaper for light theme
    gsettings set org.gnome.desktop.background picture-uri "file://$SELECTED_WALLPAPER"
fi

echo "Wallpaper changed to $SELECTED_WALLPAPER"
