#!/usr/bin/env bash

help()
{
   echo
   echo "Script to download NCBI genbank files associated with nucleotide accession ID"
   echo "Binomica labs GPLv3"
   echo
   echo "Syntax: script [-i|-a|-u|-h]"
   echo "options:"
   echo "-i    Input nucleotide accession"
   echo "-a    NCBI API key"
   echo "-u    URL mode - saves efetch URL"
   echo "-h    This help screen"
   echo
}

efetch1="'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?retmode=text&id="
efetch2="&db=nucleotide&api_key="
efetch3="&rettype=gbwithparts'"

single_acc_gbk () {
        echo 'wget -w 10 -O '$inputid.gbk $efetch1$inputid$efetch2$apikey$efetch3 > $inputid.tmp
        bash $inputid.tmp
        rm $inputid.tmp
}

single_acc_url () {
        echo 'wget -w 10 -O '$inputid.gbk $efetch1$inputid$efetch2$apikey$efetch3 > $inputid-url.txt
}

while getopts "i:a:h u" option;
do
	case "${option}" in
	i) inputid=${OPTARG};;
	a) apikey=${OPTARG};;
	u) single_acc_url exit;;
	h) help exit;;
	\?) echo "Invalid option, please run -h for help"
	exit;;
	esac
done

apikeysize=${#apikey}

if (($apikeysize < 30)); then
	printf "\n Please provide a valid NCBI API key. \n"
	printf "\n You can visit the NCBI page for more info. \n"
	printf " https://support.nlm.nih.gov/knowledgebase/article/KA-05317/en-us \n"
	printf "\n"
	exit
fi

if [ ! -f $inputid-url.txt ]; then
	single_acc_gbk
fi

