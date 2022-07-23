#!/usr/bin/bash


# Function that will create the .indfile that we need for the admixture plot (structure_threader)
indfile() {

	for id in $(cat ~/sra_seqs/ids.txt) ; # Variable id will represent each member of the list_ids
	do # Starts o loop

        	# If statement when the variable $id it's equal (-eq) to the specific id "then" it prints what's in front of the echo command
        	if [[ $id -eq 4940127 || $id -eq 4940190 || $id -eq 4940186 || $id -eq 4940128 || $id -eq 4940147 || $id -eq 4940181 || $id -eq 4940142 || $id -eq 4940183 || $id -eq 4940135 || $id -eq 4940201 || $id -eq 4940188 || $id -eq 4940184 ]];
        	then
                	echo "Sequence with the id "$id" has been taken out from having low sequence expression"

	        else # If the variable $id it's none of those specific ids in double brackets "then" does what's down below

	                # The variable country will have the purpose to store the country from each sequence/especies in the country.txt,  and will abbreviate each one of them and add the order for the admixture plot
        	        country=$(efetch -db sra -id $id -format xml | grep -o "<\TAG>.*" | sed 's/ Region.*//' | sed 's/.*<VALUE>//' | sed 's/Algeria/Algeria 1/' | sed 's/Bulgaria/Bulgaria 2/' | sed 's/Catalonia/Catalonia 3/' | sed 's/Corsica/Corsica 4/' | sed 's/Haza de Lino/Haza_de_Lino 5/' | sed 's/Kenitra/Kenitra 6/' | sed 's/Landes/Landes 7/' | sed 's/Monchique/Monchique 8/' | sed 's/Puglia/Puglia 9/' | sed 's/Sardinia/Sardinia 10/' | sed 's/Sicilia/Sicilia 11/' | sed 's/Sintra/Sintra 12/' | sed 's/Taza/Taza 13/' | sed 's/Toledo/Toledo 14/' | sed 's/Tunisia/Tunisia 15/' | sed  's/Tuscany/Tuscany 16/' | sed 's/Var/Var 17/' >> country.txt)
                	# The variable seq_name will store each sequence name from the respective id in the seq_name.txt
	                seq_name=$(efetch -db sra -id $id -format runinfo -mode txt | sed 's/_.*//' | sed 's/.*,//' >> seq_name.txt)
	                # This command will combine both txt files in different columns and then the output redirected to assignment2.indfile
	                paste seq_name.txt country.txt | column -s $'\t' -t > assignment2.indfile

	        fi # Ends if statement

	done # Ends o loop

}
# Running function above
indfile


# Function that will filter our .vcf file and then create the name_fileCenterSNP.vcf file for the structure_threader program
vcf() {

        # Copys the .vcf file to the ~/str_analyses
        cp ~/ipyrad-assembly/assignment2_outfiles/assignment2.vcf ~/str_analyses
        # This command will run vcf_parser.py script with python (it's a .py file) and create the name_fileCenterSNP.vcf that we need
        python3 vcf_parser.py --center-snp -vcf assignment2.vcf

}
# Running function above
vcf

# Here's the last command that we need to get the admixture plot. So, here we use structure_threader program to run and get the input (-i) name_fileCenterSNP.vcf file created in the previous function.
# Then we say the directory that will be created and stored all files on. Next we get the R script packeges to get the plots done, the number of K, the number of cores that your machine has and finnaly the .indfile
structure_threader run -i assignment2CenterSNP.vcf -o ./results_assignment2CenterSNP -als ~/miniconda3/envs/structure/bin/alstructure_wrapper.R -K 8 -t 2 --ind assignment2.indfile


#Function that will sort the .indfile and create the file .str for the pca.R script
pca() {

        # Sorting assignment2.indfile and redirect it to assignment2_str.indfile
        sort assignment2.indfile > ~/str_analyses/assignment2_str.indfile
        # Command join will merge the .indfile and the .str given previously from ipyrad and redirect to the assignment2_pca.str
        join assignment_str.indfile ~/ipyrad-assembly/assignment2_outfiles/assignment2.str > assignment2_pca.str
        # Executing R script that creates the scores graph of the pca analysis
        Rscript pca.R
        # Opens the plot saved in "Rplots.pdf" in the browser
        firefox Rplots.pdf

}
# Running function above
pca

