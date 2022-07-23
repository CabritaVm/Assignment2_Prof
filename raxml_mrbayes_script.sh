#!/usr/bin/bash


# This function copys the .phy file given from ipyrad run and uses raxmlHPC to obtain the trees with bootstrap
raxml() {

	cd ~/
	cp ~/ipyrad-assembly/assignment2_outfiles/assignment2.phy ~/ # Copys the assignment.phy file given from ipyrad run
	# The command raxmlHPC creates 5 different files, but the one that has its name like "RAxML_bipartitions.ass2_ResultTreeBoot" it's the one that will be used to visualize the tree using another program (figtree)
	raxmlHPC -f a -x 12347 -m GTRGAMMA -s assignment2.phy -n ass2_ResultTreeBoot -p 12347 -N 100
	mv *RA* ~/trees # Moves all files with "RA" in the begining of each file
	rm ~/assignment2.phy # Deletes assignment2.phy so that it doesn't create confusion

}
# Running function above
raxml


# Function that is responsible for the mrbayes run and the identification/set of the mrbayes block in the nexus file
mrbayes() {

	cd ~/ # Enters in the home directory
	cp ~/ipyrad-assembly/assignment2_outfiles/assignment2.nex ~/ # Copys the nexus file given from ipyrad run
	touch ~/grep_file # Creates an empty file called grep_file
	grep_file=$(cat ~/sra_seqs/seq_name.txt | sed '1,93d' | sed '2d' > ~/grep_file) # Variable that is going to get the last 2 species of the nexus file and then cutting the last name and only getting the penultimate sequence name
	sp=$(grep -m1 "" ~/grep_file | perl -pe 's/ .*?/>/' | sed 's/>.*//') # This variable takes the 1st species out of the 3 in grep_file | perl command switchs the 1st space with the ">" character | the sed command eliminates everything thats in front of the ">" character
	outgroup=$(sed 's/$sp;/'$sp';/' ~/trees/mrbayes_block.txt > ~/trees/mrbayes_set) # In this sed will switch the "$sp;" for the variable defined above ($sp) for the file mrbayes_set
	cat ~/trees/mrbayes_set | tee -a ~/assignment2.nex # Appends the set/block of mrbayes at the end of the nexus file
	mb assignment2.nex  # Runs mrbayes with the nexus file
	# MrBayes creates several files with trees and more but, the one that matter to us so that we can see the tree with the probability values is the one with "con.tre" in the file name
	mv *con.tre* ~/trees # Moves the file that has "con.tre" in the file name to the trees directory
	rm *mb_test* ~/assignment2.nex ~/grep_file # Deletes the files created (*mb_test* = every file with "mb_test" in the file name) and copied previously so that it doesn't create confusion

}
# Running function above
mrbayes

