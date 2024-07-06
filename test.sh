#!/usr/bin/env bash

function log() {
    local msg="$1"
    local datetime=$(date +"%Y-%m-%d %H:%M:%S")
    local log_file="$HOME/Desktop/EldenRingModing/DLSS/log.txt"

    echo "$datetime - $msg" >> "$log_file"
}

# Log all arguments passed to the script
log "All arguments: $@"

# Example: Check if '--mods' is present in the arguments
if [[ "$@" =~ --mods ]]; then
    log "--mods option detected"

    # Extracting the next argument after '--mods' to check if it is 'on'
    next_arg_index=$(( $(echo "$@" | grep -o -- '--mods' | wc -l) + 1 ))
    next_arg=$(echo "$@" | awk "{print \$$next_arg_index}")

    if [[ "$next_arg" == "on" ]]; then
        log "--mods on option detected"
    else
        log "--mods option detected but 'on' is not specified"
    fi

    # Extracting the command part after '%command%'
    command_index=$(( $(echo "$@" | grep -o -- '%command%' | wc -l) + 1 ))
    command=$(echo "$@" | awk "{print \$$command_index}")

    log "Executed command: $command"
else
    log "No --mods option found"
fi
