#!/usr/bin/env bash

#Taking in genome length input as an argument following the script call
genome_length="$1"

#Using shuffle command choosing from 1-4 -recursively -number of times from genome_length input
#The output is piped through tr commands swapping each of 1~4 digits for associated basepair
#Followed by tr command eliminating all whitespace (shuf default output is single letter column)
genome=$(shuf -i 1-4 -r -n "$1" | tr '1' 'A' | tr '2' 'T' | tr '3' 'C' | tr '4' 'G' | tr -d '[:space:]')

#The output is saved to a temporary file
echo "$genome" >> output.tmp

#The temporary output file is analyzed for sequence composition and GC content
#We're simply going to grep individual bases and then cat them together
grep -o 'A' output.tmp > A.tmp
grep -o 'T' output.tmp > T.tmp
grep -o 'C' output.tmp > C.tmp
grep -o 'G' output.tmp > G.tmp
cat A.tmp T.tmp C.tmp G.tmp > seq.tmp

#Uniq with -c character count command is used to output a table
uniq -c seq.tmp > seq_table.tmp

#Creating gc variable containing addition of C and G column values
gc=$(tail -n 2 seq_table.tmp | awk '{print $1}' | paste -sd+ - | bc)

#Creating gc_content variable containing gc divided by total length of genome
gc_content=$(echo "scale=2; $gc/$1*100" | bc)

#And we're adding a terminal output with the analysis of the synthetic DNA
echo "##################################################"
echo "     Total sequence composition is as follows     "
echo "--------------------------------------------------"
cat seq_table.tmp
echo "--------------------------------------------------"
echo "     GC content is $gc_content %                  "
echo "##################################################"
echo "                                                  "

#sed is used to insert a header, creating the final product
sed '1 s/^/>synthetic_fasta\n/' output.tmp  > dna_"$1".fasta

#Finally, removing all the temporary files to tidy up the directory
rm *.tmp

