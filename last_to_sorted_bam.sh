#!/usr/bin/env bash

thread="$1"
reference="$2"
query="$3"
db_name=${reference%.*}.db
query_name=$(echo "$query" | cut -d '.' -f1)

lastdb -P"$thread" "$db_name" "$reference"
last-train "$db_name" "$query" > "$query_name".train
lastal -p "$query_name".train "$db_name" "$query" > "$query_name"_aln.maf
maf-convert sam "$query_name"_aln.maf > "$query_name".sam

samtools faidx "$reference"
samtools view -t "$reference".fai -S -b "$query_name".sam | samtools sort "$query_name".bam -o "$query_name".bam
samtools index sorted_"$query_name".bam
