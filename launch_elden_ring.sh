#!/usr/bin/env bash

set -euo pipefail

MODE=$1
ARGUMENTS=${2:-off}

DEBUG="--debug"
MODS="--mods"

function debug()
{
    file_handler
}

function launch_with_dlls() {
    log "Arguments: $@"
    cmd=("$@")
    cmd[-1]="eldenring.exe"
    WINEDLLOVERRIDES="dinput8=n,b;dxgi=n,b" "${cmd[@]}"
}

function file_handler()
{
   mods_dir="~/Desktop/Elden Ring Moding/DLSS/"
   game_dir="/media/M2SSD/SteamLibrary/steamapps/common/ELDEN RING/Game/"
   files=(dxgi.dll ERSS2.dll)    
   folder="ERSS2"

    log "File handler"
    ## File handler
    for file in ${files[@]}; do
        log "Processing file: $file"
        file_dir="$game_dir$file"
        if [ -f "$file_dir" ]; then
            if [ $MODE = $MODS ] && [ $ARGUMENTS = "off" ]; then
                rm "$file_dir"
                log "File deleted $file_dir"
            fi
        elif [ $MODE = $MODS ] && [ $ARGUMENTS = "on" ]; then     
            cp "$file" "$game_dir"
            log "File copied $file to $game_dir"
        fi
    done

    log "Directory Handler"
    ## Directory handler
    folder_dir="$game_dir$folder"
    if [ -d "$folder_dir" ] && [ $MODE = $MODS ] && [ $ARGUMENTS = "off" ]; then
        log "Deleting folder with files $folder_dir"
        rm -rf "$folder_dir"
    elif [ $MODE = $MODS ] && [ $ARGUMENTS = "on" ]; then
        cp -r "$folder" "$folder_dir"
        log "Directory "$folder" copied to "$folder_dir""
    fi
}

function log() {
    local msg="$1"
    local datetime=$(date +"%Y-%m-%d %H:%M:%S")
    local log_file="$HOME/Desktop/EldenRingModing/DLSS/log.txt"

    echo "$datetime- $msg" >> "$log_file"
}

log "STARTED--- with arguments: $@"
# Launch
if [ "$#" -ge 2 ] && [ "$1" = $MODS ] && [ "$2" = "on" ]; then
    log "launch mods"
    #file_handler
    launch_with_dlls "$@"
elif [ "$#" -ge 1 ] && [ "$1" = $DEBUG ]; then
    log "launch debug"
    debug
else
    log "launch normal"
    file_handler
    gamemoderun PROTON_NO_FSYNC=1 VKD3D_FEATURE_LEVEL=12_0 %command%
fi