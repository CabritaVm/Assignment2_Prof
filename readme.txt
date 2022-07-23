# Hey, here you'll find the step by step tutorial to how to run and analyze the choosen paper

# First things first we will need to create directorys and move the scripts to each one of them respectively
# ALERT!!! Make sure you are in the home directory, run "cd ~/", if you aren't

# The commands we'll run to create directorys:
	
	$ mkdir ~/sra_seqs
	$ mkdir ~/sra_seqs/sra_1250M
	$ mkdir ~/ipyrad-assembly
	$ mkdir ~/trees
	$ mkdir ~/str_analyses

# After creating them we need to move each script to it's specific directory
	
	$ mv ~/Downloads/fasterq_script.sh ~/sra_seqs
	$ mv ~/Downloads/ipyrad_script.sh ~/ipyrad-assembly
	$ mv ~/Downloads/raxml_mrbayes_script.sh ~/trees
	$ mv ~/Downloads/mrbayes_block.txt ~/trees
	$ mv ~/Downloads/admix_pca_plot_script.sh ~/str_analyses
	$ mv ~/Downloads/pca.R ~/str_analyses

# The other alternative it's cloning (download the files) the repository from github
	# First we need to install git so that we can get the files:
		$ sudo apt install git -y 
	# Then we need to download the files in the specific repository... To do that you'll need to run the command down below:
		$ git clone "link/url of the github repo"
	# The command above will create a directory with the name of the repository you just cloned
	# So after that we'll need to move them to their respective directorys
		$ mv ~/Repo's_name/fasterq_script.sh ~/sra_seqs
	        $ mv ~/Repo's_name/ipyrad_script.sh ~/ipyrad-assembly
	        $ mv ~/Repo's_name/raxml_mrbayes_script.sh ~/trees
		$ mv ~/Repo's_name/mrbayes_block.txt ~/trees
		$ mv ~/Repo's_name/admix_pca_plot_script.sh ~/str_analyses
		$ mv ~/Repo's_name/pca.R ~/str_analyses


# Now, that the scripts are on the directorys we have to run some other commands for each one of them work

# Let's start with the fasterq_script.sh:
	
	$ sudo apt install ncbi-entrez-direct -y # We need ncbi-entrez-direct to get the sequence names and the run accession
	$ sudo apt install gzip -y # Gzip will be used for the compression of the .fastq files
	$ sudo apt install r-base -y # R-base will get the packages needed so that we can run the R script pca.R	

	# Before we keep on going we need to install miniconda too:
		
		$ wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh # It depends on your OS but here's the link, https://docs.conda.io/en/latest/miniconda.html
		$ bash Miniconda3-latest-Linux-x86_64.sh -b -f # Here we execute the scritp downloaded in the previous command
		$ conda config --add channels bioconda # Adding the bioconda channel
		$ conda config --add channels conda-forge # Adding the conda-forge channel

		$ conda create -n sra # Creates a new conda environment
		$ conda activate sra # # Activates the environment
		$ conda install sra-tools # Installs sra-tools with conda

	# Back to where we were, lets enter in the sra_seqs directory and then finnaly run the script
		
		$ cd ~/sra_seqs # Enters in sra_seqs directory previously created
		$ chmod +777 fasterq_script.sh # Giving all permitions to the script
		$ ./fasterq_script.sh or bash fasterq_script.sh # Runs the script

# After the script ends running the next step is ipyrad:
	
	$ conda create -n ipyrad # Creates a new conda environment
	$ conda activate ipyrad # Activates the environment
	$ conda install ipyrad -c bioconda # Installs ipyrad with conda

	# Running script:
		
		$ cd ~/ipyrad-assembly # Enters in ipyrad-assembly directory previously created
		$ chmod +777 ipyrad_script.sh # Giving all permitions to the script
		$ ./ipyrad_script.sh or bash ipyrad_script.sh # Runs the script

# When ipyrad ends running we can see all the output files in the directory ~/ipyrad-assembly/assignment2_outfiles
# For the raxml_mrbayes_script.sh we only need to download the packages and be in the ~/trees directory
	
	$ sudo apt install raxml -y # Install raxml
	$ sudo apt install mrbayes -y # Install mrbayes
	$ sudo apt install figtree -y # Install figtree

	# Running script:
		
		$ cd ~/trees # Enters in trees directory previously created
		$ chmod +777 raxml_mrbayes_script.sh # Giving all permitions to the script
		$ ./raxml_mrbayes_script.sh or bash raxml_mrbayes_script.sh # Runs the script

	# This script is the one that takes more time to run but, when it ends we use the figtree program to visualize and edit (colors, font, bootstraps, etc) the trees 
	# To see the trees you need to run:
		
		$ figtree name_file_tree (RAxML_bipartitions.ass2_ResultTreeBoot and the file .con.tre from MrBayes)

		# It will pop something on your screen to define the label of the bootstrap values/posterior probabilities
		# Next, we need to scpecify the species to outgroup. In our case we selected S.uniflora_56091
		# For Raxml, in order to see the bootstrap values you need to activate it's section clicking on the box of Branch Labels and then on the display section you select the label that you defined earlier
		# For MrBayes, it's the same process but we select the one that says "prob(percentage)"

# Last step of this sequence is to create the admixture plot to see the distribution of 83 species around the globe
	# To get the plot we need to get the geographic location of each specie and then combine the file with the sequence name and the country
	# First things first we need to run some commands with conda to install the packages needed:
		
		$ conda create -n structure python=3.7 r r-rcolorbrewer bioconductor-snprelate bioconductor-lfa r-devtools -c bioconda # Create a new environment with all required dependencies
		$ conda activate structure  # Activate the new environement
		$ pip install structure_threader  # Structure_threader does not have a conda package, so we install it via pip, python's package manager

		$ cd ~/str_analyses # Enters in str_analysis directory previously created
		$ wget https://raw.githubusercontent.com/CoBiG2/RAD_Tools/6648d1ce1bc1e4c2d2e4256abdefdf53dc079b8c/vcf_parser.py # In order to get the CenterSNP.vcf file we'll need this python script in the directory
                $ chmod +777 pca.R # Giving all permitions to the script
		$ chmod +777 admix_pca_plot_script.sh # Giving all permitions to the script
		$ ./admix_pca_plot_script.sh or bash admix_plot_script.sh # Runs script

	# When the script it's done you can run the next command to check the html file of the comparition admixture plots and scores graph from pca script
		$ firefox ~/str_analyses/results_assignment2CenterSNP/plots/ComparativePlot_2-3-4-5-6-7-8-9-10.html # This command will open the html file with firefox browser
		$ firefox ~/str_analyses/Rplots.pdf # Command that will open the pdf file of the plot saved from pca.R script with firefox browser

# Hope this readme file helped on the execution of the scripts :)

# Instituto Politécnico de Setúbal
# Escola Superior de Tecnologia do Barreiro
# UC Análise de Sequências Biológicas
# Teacher Francisco Pina Martins 

# Alexandre Duarte nº202000198 -> Alexyeye
# Diogo Cabrita nº202000212 -> CabritaVM
