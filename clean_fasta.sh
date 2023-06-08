#!/usr/bin/env bash

if [ ! -f "$1" ]; then
        echo "$1 not found. Please double check file location"
        echo "Exiting"
        exit 1
fi

input_genome=$1
header=$(awk '/>/' "$input_genome")
body=$(sed 1d "$input_genome" | tr -d [:space:])
output_genome="clean_$input_genome"

touch $output_genome
echo $header > $output_genome
echo $body >> $output_genome

