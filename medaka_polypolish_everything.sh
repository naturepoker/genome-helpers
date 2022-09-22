#!/usr/bin/env bash

#Checking for dependencies

if ! command -v bwa > /dev/null; then
	printf "\n Bwa not found in path. Exiting"
	exit
fi

if ! command -v medaka_consensus > /dev/null; then
	printf "\n Medaka not found in path. Exiting"
	exit
fi

if ! command -v polypolish > /dev/null; then
	printf "\n Polipolish not found in path. Exiting"
	exit
fi


#Checking to see if there are fasta files in the directory

count=`ls -1 *.fasta 2>/dev/null | wc -l`
if [ $count != 0 ]
then
	echo "Fasta files found - processing"
else
	echo "No fasta files found in directory. Exiting"
	exit
fi

threads="$1"
long_read=$(echo $2 | tr -d '\r')
short_read_1=$(echo $3 | tr -d '\r')
short_read_2=$(echo $4 | tr -d '\r')

for F in *.fasta; do
	N=$(basename $F .fasta);
	medaka_consensus -i "$long_read" -d "$F" -o medaka_$N -t "$threads" -m r941_min_sup_g507;
	rm *.fai *.mmi;
	if [[ $# == 4 ]]; then
		echo "#####################################################################";
		echo "                                                                     ";
		echo "Short reads detected as arguments 3 and 4. Proceeding with polypolish";
		echo "                                                                     ";
		echo "#####################################################################";
		mkdir polypolish_$N;
		bwa index medaka_$N/consensus.fasta;
		bwa mem -t "$threads" -a medaka_$N/consensus.fasta "$short_read_1" > polypolish_$N/alignment1.sam;
		bwa mem -t "$threads" -a medaka_$N/consensus.fasta "$short_read_2" > polypolish_$N/alignment2.sam;
		polypolish medaka_$N/consensus.fasta polypolish_$N/alignment1.sam polypolish_$N/alignment2.sam > polypolish_$N/polypolish_$F;
		rm polypolish_$N/alignment1.sam polypolish_$N/alignment2.sam;
		rm -rf medaka_$N;
	else
		echo "Short reads not provided for $F";
	fi;
done

	echo "#############################"
	echo "                             "
	echo "$F polishing finished"
	echo "                             "
	echo "#############################"

