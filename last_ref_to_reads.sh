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
raw_reads=$(echo $3 | tr -d '\r')

samtools faidx "$ref_genome"
lastdb -P "$threads" -uNEAR "${ref_genome%.*}" "$ref_genome"
last-train -P "$threads" -Q0 "${ref_genome%.*}" "$raw_reads" > "${ref_genome%.*}".train
lastal -P "$threads" -m100 -D1e9 -p "${ref_genome%.*}".train "${ref_genome%.*}" "$raw_reads" | last-split > "${ref_genome%.*}".maf
maf-convert sam "${ref_genome%.*}".maf > "${ref_genome%.*}".sam
samtools view -t "$ref_genome".fai -S -b "${ref_genome%.*}".sam | samtools sort -o "${ref_genome%.*}".bam
samtools index "${ref_genome%.*}".bam
bedtools bamtobed -i "${ref_genome%.*}".bam > "${ref_genome%.*}".bed
awk '{print $4}' "${ref_genome%.*}".bed | sort | uniq > "${ref_genome%.*}".reads
wc -l "${ref_genome%.*}".reads

