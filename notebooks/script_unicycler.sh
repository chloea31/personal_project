#!/bin/bash

#######################################################################################################################################################
#######################################################################################################################################################
#*/                                                   INTRODUCTION TO GENOME ASSEMBLY USING UNICYCLER                                               /*#
#######################################################################################################################################################
#######################################################################################################################################################


####################
### Activate the working environment
####################

conda activate EnvVelvet

####################
### Running the pipeline
####################

# in /home/Documents/Bioinformatique/personal_project/notebooks/ tape: ./script_unicycler.sh

####################
### Variable initialization
####################

SITE="https://zenodo.org/record/940733/files/"
WORK_DIR=/home/Documents/Bioinformatique/personal_project/ # work directory

####################
### Data collection
####################
echo "> download the datasets"

if [ ! -d $WORK_DIR/data ]; then
    mkdir $WORK_DIR/data
fi 
if [ ! -d $WORK_DIR/data/raw ]; then 
    mkdir $WORK_DIR/data/raw
fi
if [ ! -d $WORK_DIR/data/interm ]; then
    mkdir $WORK_DIR/data/interm
fi
if [ ! -d $WORK_DIR/data/processed ]; then
    mkdir $WORK_DIR/data/processed
fi
for file in $SITE; do
        
done 

####################
### Evaluate the input reads
####################

mkdir data
mkdir raw
cd data/raw/

wget https://zenodo.org/record/940733/files/illumina_f.fq
wget https://zenodo.org/record/940733/files/illumina_r.fq
wget https://zenodo.org/record/940733/files/minion_2d.fq

du -sh *

# Quality control of the data
fastqc illumina_f.fq -o ../../reports/QC/
fastqc illumina_r.fq -o ../../reports/QC/

# MultiQC on FASTQ files
multiqc ../fastqc/*_fastqc.zip

#################
### Assemble reads with Unicycler
#################

unicycler -1 data/raw/illumina_f.fq -2 data/raw/illumina_r.fq -l data/raw/minion_2d.fq -o reports/assembly/
grep ">" assembly.fasta | wc -l

#################
### Assess Assembly quality with Quast
#################

#################
### Genome annotation using Prokka
#################


