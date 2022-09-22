#!/usr/bin/env bash

ref_genome=$(echo $1 | tr -d '\r')
raw_reads=$(echo $2 | tr -d '\r')

samtools faidx "$ref_genome"
lastdb -P14 -uNEAR "${ref_genome%.*}" "$ref_genome"
last-train -P14 -Q0 "${ref_genome%.*}" "$raw_reads" > "${ref_genome%.*}".train
lastal -P14 -m100 -D1e9 -p "${ref_genome%.*}".train "${ref_genome%.*}" "$raw_reads" | last-split > "${ref_genome%.*}".maf
maf-convert sam "${ref_genome%.*}".maf > "${ref_genome%.*}".sam
samtools view -t "$ref_genome".fai -S -b "${ref_genome%.*}".sam | samtools sort -o "${ref_genome%.*}".bam
samtools index "${ref_genome%.*}".bam
bedtools bamtobed -i "${ref_genome%.*}".bam > "${ref_genome%.*}".bed
awk '{print $4}' "${ref_genome%.*}".bed | sort | uniq > "${ref_genome%.*}".reads
wc -l "${ref_genome%.*}".reads

