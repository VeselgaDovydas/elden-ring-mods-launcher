#!/usr/bin/env bash

set -euo pipefail

MODE=$1
ARGUMENTS=${2:-off}

DEBUG="--debug"
MODS="--mods"
MODS_DIR="$HOME/Desktop/EldenRingModing/DLSS/" ## todo refactor for new mods later
GAME_DIR="/media/M2SSD/SteamLibrary/steamapps/common/ELDEN RING/Game/"

function launch_with_dlls() {
    sleep 1
    local cmd=("$@")
    cmd[-1]="eldenring.exe"
    WINEDLLOVERRIDES="dinput8=n,b;dxgi=n,b" "${cmd[@]}"
}

function file_handler() {
    #local mods_dir="$HOME/Desktop/EldenRingModing/DLSS/"
    #local game_dir="/media/M2SSD/SteamLibrary/steamapps/common/ELDEN RING/Game/"
    local files=("dxgi.dll" "ERSS2.dll")
    local folder="ERSS2"
    local enabled=$1

    log "File handler start"
    ## File handler
    for file in "${files[@]}"; do
        local file_dir="$GAME_DIR$file"
        #log "Processing file: $file, filedir $file_dir"
        if [ -f "$file_dir" ]; then
            #log "file found, enabled: $enabled, mode: $MODE"
            if [ "$MODE" = "$MODS" ] && [ "$enabled" = "off" ]; then
                rm "$file_dir"
                #log "File deleted: $file_dir"
            fi
        else
            #log "file not found, enabled: $enabled, mode: $MODE"
            if [ "$MODE" = "$MODS" ] && [ "$enabled" = "on" ]; then
                #log "File trying to copy: cp $MODS_DIR$file $GAME_DIR"
                cp "$MODS_DIR$file" "$GAME_DIR"
            fi
        fi
        #log "Processing file finished: $file_dir"
    done

    log "Directory Handler"
    ## Directory handler
    folder_dir="$GAME_DIR$folder"
    if [ -d "$folder_dir" ] && [ $MODE = $MODS ] && [ $enabled = "off" ]; then
        #log "Deleting folder with files $folder_dir"
        rm -rf "$folder_dir"
    elif [ $MODE = $MODS ] && [ $enabled = "on" ]; then
        #log "Directory: cp -r '$MODS_DIR/$folder' '$GAME_DIR'"
        cp -r "$MODS_DIR$folder" "$GAME_DIR"
    fi
    log "Finished handler"
}

function log() {
    local msg="$1"
    local datetime=$(date +"%Y-%m-%d %H:%M:%S")
    local log_file="${MODS_DIR}log.txt"

    echo "$datetime - $msg" >> "$log_file"
}

# Launch
if [ "$#" -ge 2 ] && [ "$1" = "$MODS" ] && [ "$2" = "on" ]; then
    log "Launch with mods"
    file_handler $2
    launch_with_dlls "${@:3}"  # Skip the first two arguments --mods and on
    log "Starting game"
else
    log "Launch normal"
    file_handler $2
    gamemoderun PROTON_NO_FSYNC=1 VKD3D_FEATURE_LEVEL=12_0 "${@:3}"  # Execute %command%
    log "Starting game"
fi
