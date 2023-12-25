#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "Usage: ./script.sh <program path> <period time(t) in minutes>"
    exit 1
fi

program_path=$1
period=$2

if [[ ! -f $program_path ]]; then
    echo "Error: program path is not a file"
    exit 2
fi

output_file="output_$(date +%Y%m%d_%H%M%S).log"
error_file="error_$(date +%Y%m%d_%H%M%S).log"

execute_program() {
    echo > running.lock
    $program_path >> $output_file 2>> $error_file
    rm running.lock
}

while true; do
    if [[ ! -e "running.lock" ]]; then
        execute_program &
        echo "Program has started."
    else
        echo "Program is running. Waiting for finish..."
    fi
    sleep $(($period * 60))
done