#!/usr/bin/env Rscript


# Function that will be responsible for the download of the packages needed 
install_BiocManager = function() {

	if (!requireNamespace("BiocManager", quietly = TRUE)) {
		install.packages("BiocManager")
		BiocManager::install("pcaMethods")
	}

}


# Function that will read our data file and assign it to the variable snp_data that will be used in other functions (that's why it's in the return statement)
read_data = function() {

	snp_data = read.csv(file = 'assignment2_pca.str',
                      header=FALSE, 
                      sep=" ") 
  
	return(snp_data)

}


# Function return the number of the regions of the samples 
num_regions = function(snp_data) {

	num_region_classes <- factor(snp_data$V3)  
  
	return(num_region_classes)

}


# Function that will calculate PCA 
create_pca = function(snp_data) {

	quercus_pca <- pca(snp_data[, -1], 
                    scale="none", 
                    center=T, 
                    nPcs=2, 
                    method="nipals") 
	
	str(quercus_pca)
	print(quercus_pca@R2)
	return(quercus_pca)

}


# Function that will plot the PCA scores graphic
plot_pca = function(snp_data,quercus_pca,num_region_classes) {
  
	slplot(quercus_pca, 
		scol=num_region_classes, 
		scoresLoadings=c(TRUE,FALSE),
		sl=NULL, 
		spch=1) 
  
	legend("bottomright",
		legend=sort(unique(snp_data$V2)),
		col = c("blue", "cadetblue1", "brown", "darkgoldenrod1", 
			"darkorchid", "hotpink", "orangered3", "red", 
			"yellow", "lightcoral", "navy", "peru", "black",
			"sienna4", "purple4", "slategrey", "green"),
		pch=1)

}


# Execution of all the functions
install_BiocManager()
library(pcaMethods) # Calling "pcaMethods" package so that we can use/activate  it's features
snp_data <- read_data()
num_region_classes <- num_regions(snp_data)
quercus_pca <- create_pca(snp_data)
plot_pca(snp_data,quercus_pca,num_region_classes)




