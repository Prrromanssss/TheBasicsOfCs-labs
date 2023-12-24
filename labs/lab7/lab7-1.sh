#!/bin/bash

if [[ "$#" -ne 2 ]]; then
    echo "Usage: $0 <filename> <period time>"
fi


file_path=$1
per_time=$2

while true; do
    timestamp=$(date +%Y%m%d%H%M%S)
    output_log="output_$timestamp.log"
    error_log="error_$timestamp.log"
  
    if [[ -f $file_path ]]; then
        touch $output_log
        echo "file exists" > $output_log
    fi

    if [[ ! -f $file_path ]]; then
        touch $error_log
        echo "file doesn't exist" > $error_log
    fi

    sleep $per_time 
done