#!/usr/bin/env bash

#Checking for dependencies

if ! command -v flye > /dev/null; then
	printf "\n Flye not found in path. Exiting"
	exit
fi

if ! command -v miniasm_and_minipolish.sh > /dev/null; then
	printf "\n Miniasm not found in path. Exiting"
	exit
fi

if ! command -v raven > /dev/null; then
	printf "\n Raven not found in path. Exiting"
	exit
fi

if ! command -v shasta > /dev/null; then
	printf "\n Shasta not found in path. Exiting"
	exit
fi

if ! command -v any2fasta > /dev/null; then
	printf "\n any2fasta not found in path. Exiting"
	exit
fi


#Starting assembly

threads=$1
raw_reads=$(echo $2 | tr -d '\r')

mkdir assemblies

flye --nano-raw "$raw_reads" --threads "$threads" --out-dir assembly_01 && cp assembly_01/assembly.fasta assemblies/flye_01.fasta && rm -r assembly_01
miniasm_and_minipolish.sh "$raw_reads" "$threads" > assembly_02.gfa && any2fasta assembly_02.gfa > assemblies/miniasm_01.fasta && rm assembly_02.gfa
raven --threads "$threads" "$raw_reads" > assemblies/raven_01.fasta && rm raven.cereal
shasta --threads "$threads" --config Nanopore-Oct2021 --input "$raw_reads" --assemblyDirectory assembly_04 && cp assembly_04/Assembly.fasta assemblies/shasta_01.fasta && rm -rf assembly_04

flye --nano-raw "$raw_reads" --threads "$threads" --out-dir assembly_05 && cp assembly_05/assembly.fasta assemblies/flye_02.fasta && rm -r assembly_05
miniasm_and_minipolish.sh "$raw_reads" "$threads" > assembly_06.gfa && any2fasta assembly_06.gfa > assemblies/miniasm_02.fasta && rm assembly_06.gfa
raven --threads "$threads" "$raw_reads" > assemblies/raven_02.fasta && rm raven.cereal
shasta --threads "$threads" --config Nanopore-Oct2021 --input "$raw_reads" --assemblyDirectory assembly_08 && cp assembly_08/Assembly.fasta assemblies/shasta_02.fasta && rm -rf assembly_08

flye --nano-raw "$raw_reads" --threads "$threads" --out-dir assembly_09 && cp assembly_09/assembly.fasta assemblies/flye_03.fasta && rm -r assembly_09
miniasm_and_minipolish.sh "$raw_reads" "$threads" > assembly_10.gfa && any2fasta assembly_10.gfa > assemblies/miniasm_03.fasta && rm assembly_10.gfa
raven --threads "$threads" "$raw_reads" > assemblies/raven_03.fasta && rm raven.cereal
shasta --threads "$threads" --config Nanopore-Oct2021 --input "$raw_reads" --assemblyDirectory assembly_12 && cp assembly_12/Assembly.fasta assemblies/shasta_03.fasta && rm -rf assembly_12

flye --nano-raw "$raw_reads" --threads "$threads" --out-dir assembly_13 && cp assembly_13/assembly.fasta assemblies/flye_04.fasta && rm -r assembly_13
miniasm_and_minipolish.sh "$raw_reads" "$threads" > assembly_14.gfa && any2fasta assembly_14.gfa > assemblies/miniasm_04.fasta && rm assembly_14.gfa
raven --threads "$threads" "$raw_reads" > assemblies/raven_04.fasta && rm raven.cereal
shasta --threads "$threads" --config Nanopore-Oct2021 --input "$raw_reads" --assemblyDirectory assembly_16 && cp assembly_16/Assembly.fasta assemblies/shasta_04.fasta && rm -rf assembly_16
