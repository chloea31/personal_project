#!/bin/bash

#######################################################################################################################################################
#######################################################################################################################################################
#*/                                                   INTRODUCTION TO GENOME ASSEMBLY USING UNICYCLER                                               /*#
#######################################################################################################################################################
#######################################################################################################################################################


##########
# Evaluate the input reads
##########

conda activate EnvVelvet
mkdir data
mkdir raw
cd data/raw/

wget https://zenodo.org/record/940733/files/illumina_f.fq
wget https://zenodo.org/record/940733/files/illumina_r.fq
wget https://zenodo.org/record/940733/files/minion_2d.fq

du -sh *

# Quality control of the data
fastqc illumina_f.fq
fastqc illumina_r.fq

# MultiQC on FASTQ files
multiqc ../fastqc/*_fastqc.zip

##########
# Assemble reads with Unicycler
##########


