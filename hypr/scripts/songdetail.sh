#!/bin/bash

# Use 'firefox*' to match any instance of Firefox, like firefox.instance_1_105
PLAYER_NAME="firefox*" 

# Check if the player is running and get the metadata
# Note: Added '2>/dev/null' to suppress error output if no player is found
song_info=$(playerctl -p "$PLAYER_NAME" metadata --format '{{title}}      {{artist}}' 2>/dev/null)

# Check if song_info is empty (meaning playerctl failed) before echoing
if [ -n "$song_info" ]; then
    echo "$song_info"
fi
