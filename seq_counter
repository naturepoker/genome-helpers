#!/usr/bin/env bash


#Declaring input file that follows the script call- this one's really for human readability

input_seq="$1"

#We should print something simple on the screen to let the user know the script has launched successfully

echo "##################################################"
echo "Processing $1"
echo "##################################################"
echo "                                                  "
echo "                                                  "
echo "                                                  "

#Below three active code lines are essentially filtering the sequence input for processing
#Using sed to remove possible fasta headers, since it will interfere with character counting later
#In this code, it will delete any whole line beginning with >, as indicated by the d tag at the end
#The input file will go through sed first, with the result saved as an external file with _headless tag
#I'm using the .ctmp extension to make deletion of temporary working files easier at the end of the script

sed '/^>/d' < "$1" > "$1"_headless.ctmp

#The _headless.ctmp is catted into tr , with -d (deletion) tag and [:space:] option
#The [:space:] removes all horizontal and vertical whitespace from the input file

cat "$1"_headless.ctmp | tr -d '[:space:]' > "$1"_raw.ctmp

#The cleaned up input file ( _raw.ctmp now ) is further tr'd to turn any lowercase letters to uppercase

cat "$1"_raw.ctmp | tr '[:lower:]' '[:upper:]' > "$1"_clean.ctmp

#Now that the input file is filtered (no header, no whitespace, all uppercase) we use grep with -o option
#With the -o option, the command will only retrieve the individual letters matching the request, A,T,C,G, and N
#When below command is used outside the script, it will simply output a file composed of a column of one letters
#For example, 3000 As in one column if the sequence contains 3000 As among other things

grep -o 'A' "$1"_clean.ctmp > A.ctmp
grep -o 'T' "$1"_clean.ctmp > T.ctmp
grep -o 'C' "$1"_clean.ctmp > C.ctmp
grep -o 'G' "$1"_clean.ctmp > G.ctmp
grep -o 'N' "$1"_clean.ctmp > N.ctmp

#Each of the single base column streams are output as external files and then cat'd together again for the next part
#We're doing this for now since some of the lower power machines exceeded their max argument number
#in the previous version which just passed specific variables per base read

cat A.ctmp T.ctmp C.ctmp G.ctmp N.ctmp > gapped.ctmp
cat A.ctmp T.ctmp C.ctmp G.ctmp > ungapped.ctmp

#Here we're using uniq command with -c character count option, which results in two column output
#First column is the number of occurrence of each character, and the second column is the character itself
#ex. 3000 A, 3000 C, and etc etc
#We could have used many different ways to calculate the character/base count independently and output it to the user
#We're simply using uniq -c for sake of convenience, since its output is pre-formatted for easy analysis

uniq -c gapped.ctmp > gapped_list.ctmp
uniq -c ungapped.ctmp > ungapped_list.ctmp

#For deriving the total bases in a sequence we're going to create two variables for gapped and ungapped total lengths
#Remember that in bash you shouldn't place spaces between the variable=$function scheme
#Here the variable contains a value of uniq -c's first column all added together via awk command
#sum tells awk to add, $1 for awk is refers to the first column, and the second bracket tells awk to print the resulting sum

gapped_total=$(uniq -c gapped.ctmp | awk '{sum += $1}END{print sum}')
ungapped_total=$(uniq -c ungapped.ctmp | awk '{sum += $1}END{print sum}')

#Now we'll take the established files and variables to calculate the GC content of the given sequence
#First, we'll use tail to isolate the last two lines of the uniq -c output
#And we're going to use awk to isolate the first column containing only the base count
#The last two lines of the first column will always contain G and C count numbers- we add + to the output using paste
#And call bc to add the two values together. This gives us the variable gc containing total G and C base counts in the sequence

gc=$(tail -n 2 gapped_list.ctmp | awk '{print $1}' | paste -sd+ - | bc)

#Now it's just a matter of creating a variable containing the GC base numbers divided by the total number of known bases 
#We simply divide the gc variable against the ungapped sequence total variable using bc- scale tag sets the accuracy

gc_content=$(echo "scale=4 ; $gc/$ungapped_total*100" | bc | cut -c-5)

#Below is the final output, what the user will actually see after running the script
#The uniq -c output is simply displayed via cat command
#Notice how echo treats the $variables for gapped and ungapped totals embedded in the terminal output

echo "##################################################"
echo "     Total sequence composition is as follows     "
echo "--------------------------------------------------"
cat gapped_list.ctmp
echo "--------------------------------------------------"
echo "Total gapped sequence length is: $gapped_total"
echo "--------------------------------------------------"
echo "Total ungapped sequence length is: $ungapped_total"
echo "--------------------------------------------------"
echo "GC content in $1 is $gc_content %                 "
echo "##################################################"
echo "                                                  "

#And now, we remove all .ctmp files created in the directory during the course of the script using the wildcard *
#Remember, below command will remove ALL files ending in .ctmp
#When writing commands like such into a script it would be necessary to check if your tmp extension is used by some other program
#While manually creating temporary files and removing them at the end of the step can get very messy
#They can be a good tool for troubleshooting and debugging your script as well, so there are upsides as well

rm *.ctmp

