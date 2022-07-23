#!/usr/bin/bash


# Function that will execute ipyrad with the files gotten from the fasterq_script
steps_ipyrad(){

	ipyrad -n assignment2 # Creates the parameters file to run the program

	# Set of sed that will get the line (number after the ' character) and will change as is written in the same sed command and will redirect to another file
	# Doing this, we shall call it a "waterfall" methodology
	sed '6 c\~/sra_seqs/sra_1250M/*.gz                              ## [4] [sorted_fastq_path]: Location of demultiplexed/sorted fastq files' params-assignment2.txt > params-assignment2.txt1
	sed '10 c\A TGCA,                         ## [8] [restriction_overhang]: Restriction overhang (cut1,) or (cut1, cut2)' params-assignment2.txt1 > params-assignment2.txt2
	sed '27 c\0, 90, 0, 0                     ## [25] [trim_reads]: Trim raw read edges (R1>, <R1, R2>, <R2) (see docs)' params-assignment2.txt2 > params-assignment2.txt3
	sed '29 c\*                        ## [27] [output_formats]: Output formats (see docs)' params-assignment2.txt3 > params-assignment2.txt4

	cp 'params-assignment2.txt4' 'params-assignment2.txt' # Copys the final file (tottaly changed) to the inicial file created from ipyrad
	rm *txt1 *txt2 *txt3 *txt4 # Deletes all the files created after from the "waterfall" methodology

	ipyrad -p 'params-assignment2.txt' -s 1234567 -c 2 # Runs ipyrad with 2 cores (-c -> number of cores that your machine has) and does all 7 steps for all the .gz files in ~/sra_seqs
	ipyrad -p 'params-assignment2.txt' -r # Shows the stats of the process and shows where the files from each step stored in

}
# Running the function above with the variable
steps_ipyrad

