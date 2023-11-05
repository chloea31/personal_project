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
FILES="illumina_f.fq illumina_r.fq minion_2d.fq"

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

for file in $FILES; do # for loop iterates over a table
    if [ ! -f $WORK_DIR/data/raw/$file ]; then 
        wget -P $WORK_DIR/data/raw/ $SITE/$file
    fi      
done 

#wget https://zenodo.org/record/940733/files/illumina_f.fq
#wget https://zenodo.org/record/940733/files/illumina_r.fq
#wget https://zenodo.org/record/940733/files/minion_2d.fq

du -sh *

####################
### Quality control of the data
####################
echo "> quality control of the data"

#fastqc illumina_f.fq -o ../../reports/QC/
#fastqc illumina_r.fq -o ../../reports/QC/
#fastqc minion_2d.fq -o ../../reports/QC/

for file in $WORK_DIR/data/raw/*.fq; do 
    if [ ! -d $WORK_DIR/reports ]; then 
        mkdir $WORK_DIR/reports
    fi
    if [ ! -d $WORK_DIR/reports/QC ]; then
        mkdir $WORK_DIR/reports/QC
    fi
    fastqc $file -o $WORK_DIR/reports/QC/
done

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


