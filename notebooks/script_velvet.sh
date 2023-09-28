#!/bin/bash

#######################################################################################################################################################
#######################################################################################################################################################
#*/                                                   INTRODUCTION TO GENOME ASSEMBLY USING VELVET                                                  /*#
#######################################################################################################################################################
#######################################################################################################################################################


##########
# Evaluate the input reads
##########

cd /mnt/d/Bioinformatique/personal_project
mkdir data
mkdir raw
cd data/raw/

wget https://zenodo.org/record/582600/files/mutant_R1.fastq
wget https://zenodo.org/record/582600/files/mutant_R2.fastq
wget https://zenodo.org/record/582600/files/wildtype.fna

du -sh mutant_R1.fastq
du -sh mutant_R2.fastq
du -sh wildtype.fna
