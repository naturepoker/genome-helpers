#!/usr/bin/env bash

if [ ! -f "$1" ]; then
        echo "$1 not found. Please double check file location"
        echo "Exiting"
        exit 1
fi

input_gbk=$1
name=$(basename $input_gbk .gbk)
header=$(echo '>'"$name")
sequence=$(sed -n '/^ORIGIN/ { :a; n; p; ba; }' $input_gbk | awk '{print $2,$3,$4,$5,$6,$7}' | tr -d [:space:])
output_fasta="$name".fasta

touch $output_fasta
echo $header > $output_fasta
echo $sequence >> $output_fasta
