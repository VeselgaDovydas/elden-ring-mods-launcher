#!/bin/bash

function log() {
    local msg="$1"
    local datetime=$(date +"%Y-%m-%d %H:%M:%S")
    local log_file="$HOME/Desktop/EldenRingModing/DLSS/log.txt"

    echo "$datetime- $msg" >> "$log_file"
}

log "launch with arguments: '$@'"

cmd=("$@")
cmd[-1]="eldenring.exe"
WINEDLLOVERRIDES="dinput8=n,b;dxgi=n,b" "${cmd[@]}"
