#!/usr/bin/env bash

help()
{
   echo
   echo "Script to download NCBI genbank files associated with nucleotide accession ID"
   echo "Binomica labs GPLv3"
   echo
   echo "Syntax: script [-i|-a|-h]"
   echo "options:"
   echo "-i    Input nucleotide accession"
   echo "-a    NCBI API key"
   echo "      You can visit the NCBI page for more info"
   echo "      https://support.nlm.nih.gov/knowledgebase/article/KA-05317/en-us"
   echo "-h    This help screen"
   echo
}

efetch1="'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?retmode=text&id="
efetch2="&db=nucleotide&api_key="
efetch3="&rettype=gbwithparts'"
today=$(date +"%Y%m%d_%H%M")

while getopts "i:a:h" option;
do
	case "${option}" in
	i) inputid=${OPTARG};;
	a) apikey=${OPTARG};;
	h) help exit;;
	\?) echo "Invalid option, please run -h for help"
	exit;;
	esac
done

if [[ -f $inputid ]];
then
	while IFS= read -r line; do
	echo $line > /dev/null
	echo 'wget -w 20 -O '$line.gbk $efetch1$line$efetch2$apikey$efetch3 >> $today.txt
	done < $inputid
fi
