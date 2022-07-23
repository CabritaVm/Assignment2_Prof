#!/usr/bin/bash


# Variable where we'll get the ids from every 95 sequences
ids=$(wget 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi//?db=sra&term=PRJNA413625&retmax=100&usehistory=yes' -O - | grep -i "<Id>.*</Id>" | sed 's/<Id>//' | sed 's/<\/Id>//' > ids.txt)


# This function will get the run accession and the sequence name and append the output in the respective files
accn_name() {

	for id in $(cat ids.txt); # Variable id will represent each member of the ids.txt file
	do # Starts loop

        	# If statement when the variable $id it's equal (-eq) to the specific id "then" it prints what's in front of the echo command
	        if [[ $id -eq 4940127 || $id -eq 4940190 || $id -eq 4940186 || $id -eq 4940128 || $id -eq 4940147 || $id -eq 4940181 || $id -eq 4940142 || $id -eq 4940183 || $id -eq 4940135 || $id -eq 4940201 || $id -eq 4940188 || $id -eq 4940184 ]];
	        then
			echo "Sequence with the id "$id" has been taken out from having low sequence expression"

		else # If the variable $id it's none of those specific ids in double brackets "then" does what's down below

	        	# The variable run_accn will have the purpose to store each run accession in the file run_accn.txt
	        	run_accn=$(efetch -db sra -id $id -format runinfo -mode txt | sed 's/,.*//' >> run_accn.txt)
	        	# The variable seq_name will store each sequence name from the respective id in the seq_name.txt
	        	seq_name=$(efetch -db sra -id $id -format runinfo -mode txt | sed 's/_.*//' | sed 's/.*,//' >> seq_name.txt)

		fi # Ends if statement

	done # Ends loop

}
# Running function above
accn_name


# Here we define that the variable "number" is equal to 1 so that we can know how many sequences did the script run already and how many are missing
number=1


# Function that will read each line of two file simultaneously and then use the program fasterq-dump to get the .fastq from each sequence/especies
fasterq() {

	run_accn=$(wc -l run_accn.txt | cut -d\  -f 1 ) # Defines the run_accn variable
	seq_name=$(wc -l seq_name.txt | cut -d\  -f 1 ) # Defines the seq_name variable
	i=1 j=1 # Variables that will be used to represent each line of both files

	while [ $i -le $run_accn -a $j -le $seq_name ]; # Defines the condition of the while loop that is, for example, if i=2 and j=2 it will be reading the 2nd line of both files
	do # Starts loop

        	name=$(sed -n -e "${j}p" seq_name.txt) # Variable that will define and get each line from seq_name.txt file
        	accn=$(sed -n -e "${i}p" run_accn.txt) # Variable that will define and get each line from run_accn.txt file
        	echo "number = " $number # Prints the number of the sequence that the program is running
        	let "number+=1" # This will increment 1 in the variable "number" till the last run
        	echo "seq_name = " $name # Prints the sequence name that the program is running
        	echo "run_accn = " $accn # Prints the run accession that the program is running
        	fasterq-dump --outfile $name'.fastq' $accn # Runs fasterq-dump with the respective accn and defines the name that the output file will get
        	cat $name'.fastq' | head -n 1250000 > ~/sra_seqs/sra_1250M/$name'.fastq' # Cuts only the first 250 thousand lines in the .fastq file to use to analyse
        	i=$(( i + 1 )); j=$(( j + 1 )) # Variable that raises i and j variables (the lines) while it's in the loop

	done # Ends loop

}
# Running function above
fasterq


# This function will compress/zip the .fastq files so that they can be used next in ipyrad
gzips() {

	for seq_name in $(cat seq_name.txt); # The variable seq_name represents each line in the seq_name.txt
	do # Starts loop

        	cd sra_1250M # Enters sra_250m directory to zip the cutted fastq files
        	gzip $seq_name'.fastq' # Runs gzip program so that each sequence file is compressed (sequence_name.fastq -> sequence_name.fastq.gz)
        	cd ~/sra_seqs/ # Returns to sra_seqs directory

	done # Ends loop

}
# Running function above
gzips



