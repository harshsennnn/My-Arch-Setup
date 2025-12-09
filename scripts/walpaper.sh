#!/usr/bin/env bash

# Folder containing your wallpapers
WALLDIR="$HOME/Pictures/wallpaper"

# Pick a random image
IMG="$(find "$WALLDIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | shuf -n 1)"

[ -z "$IMG" ] && echo "No images found in $WALLDIR" && exit 1

# Get average brightness of wallpaper (0-100)
BRIGHTNESS=$(convert "$IMG" -colorspace Gray -format "%[fx:100*mean]" info:)

# ALWAYS use dark pywal (for Kitty and other apps)
wal -i "$IMG" -n -q

# Generate custom Waybar colors based on brightness
if (( $(echo "$BRIGHTNESS > 50" | bc -l) )); then
    # Light wallpaper → Waybar uses dark theme (dark text on white bg)
    echo "Light wallpaper detected (brightness: $BRIGHTNESS), Waybar using dark theme"
    
    cat > ~/.cache/wal/colors-waybar-custom.css << EOF
/* Custom Waybar colors for light wallpaper */
@define-color background #ffffff;
@define-color foreground #000000;
@define-color color1 #e0e0e0;
@define-color color2 #d0d0d0;
@define-color color3 #c0c0c0;
@define-color color4 #b0b0b0;
@define-color color5 #a0a0a0;
@define-color color6 #909090;
@define-color color7 #808080;
@define-color color8 #707070;
@define-color color9 #ff0000;
@define-color power-profile-color #000000;
EOF

else
    # Dark wallpaper → Waybar uses light theme (light text on dark bg)
    echo "Dark wallpaper detected (brightness: $BRIGHTNESS), Waybar using light theme"
    
    cat > ~/.cache/wal/colors-waybar-custom.css << EOF
/* Custom Waybar colors for dark wallpaper */
@define-color background #1a1a1a;
@define-color foreground #ffffff;
@define-color color1 #2a2a2a;
@define-color color2 #3a3a3a;
@define-color color3 #4a4a4a;
@define-color color4 #5a5a5a;
@define-color color5 #6a6a6a;
@define-color color6 #7a7a7a;
@define-color color7 #8a8a8a;
@define-color color8 #9a9a9a;
@define-color color9 #ff0000;
@define-color power-profile-color #ffffff;
EOF

fi

# Apply wallpaper via hyprpaper (to all monitors)
hyprctl hyprpaper preload "$IMG"
hyprctl hyprpaper wallpaper ",$IMG"

# Reload Waybar with new colors
sleep 0.5
pkill -SIGUSR2 waybar

echo "Wallpaper set: $IMG"

