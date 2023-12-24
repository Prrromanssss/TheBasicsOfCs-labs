#!/bin/bash

if [[ "$#" -ne 2 ]]; then
    echo "Usage: $0 <filename> <period time>"
    exit 1
fi


script_path=$1
per_time=$2

timestamp=$(date +%Y%m%d%H%M%S)
output_log="output_$timestamp.log"
error_log="error_$timestamp.log"
while true; do
    $program_path >> $output_log 2>> $error_log
    sleep $(( $per_time*60))
done