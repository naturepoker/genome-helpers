#!/usr/bin/env bash

#Checking for dependencies

if ! command -v lastal > /dev/null; then
        printf "\n LastAlign not found in path. Exiting"
        exit
fi

if ! command -v samtools > /dev/null; then
        printf "\n Samtools not found in path. Exiting"
        exit
fi

if ! command -v bedtools > /dev/null; then
        printf "\n Bedtools not found in path. Exiting"
        exit
fi


threads=$1
ref_genome=$(echo $2 | tr -d '\r')
comp_genome=$(echo $3 | tr -d '\r')

samtools faidx "$ref_genome"
#-uMAM8 here for higher sensitivity -uMAM4 for slighlty less for half memory
#-uNEAR for short and strong similarities, and those with many indel gaps
#-YASS for long and weak similarities
#-uRY4~32 checking only 1/4~1/32 positions
lastdb -P "$threads" -uMAM8 "${ref_genome%.*}"_db "$ref_genome"
#-D for query letters per random alignment, default at 1e6
#--sample-number for number of random samples
#--revsym for forcing reverse symmetry match
last-train -P "$threads" -D1e9 --sample-number=5000 "${ref_genome%.*}"_db "$comp_genome" > "${ref_genome%.*}".train
#-m for maximum initial matches per query position, default 10
lastal -P "$threads" -D1e9 -m100 -p "${ref_genome%.*}".train "${ref_genome%.*}"_db "$comp_genome" | last-split > "${ref_genome%.*}"_"${comp_genome%.*}".maf
maf-convert sam "${ref_genome%.*}"_"${comp_genome%.*}".maf > "${ref_genome%.*}"_"${comp_genome%.*}".sam
samtools view -t "$ref_genome".fai -S -b "${ref_genome%.*}"_"${comp_genome%.*}".sam | samtools sort -o "${ref_genome%.*}"_"${comp_genome%.*}".bam
samtools index "${ref_genome%.*}"_"${comp_genome%.*}".bam
samtools coverage -A -w 80 "${ref_genome%.*}"_"${comp_genome%.*}".bam
