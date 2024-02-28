#!/bin/bash

###########################################################################################################
###########################################################################################################
#*/                              INTRODUCTION TO GENOME ASSEMBLY USING SPADES                           /*#
###########################################################################################################
###########################################################################################################

####################
### Activate the working environment
####################

#conda activate EnvSPAdes

####################
### Running the pipeline
####################

# in /home/Documents/Bioinformatique/personal_project/ tape: ./notebooks/spades/script_spades.sh

####################
### Variable initialization
####################

SITE="https://zenodo.org/record/582600/files" # let's use the same Illumina data as Velvet assembler
WORK_DIR="$PWD" # working directory -> absolute way of the current (working) directory
FILES="mutant_R1.fastq mutant_R2.fastq wildtype.fna"

####################
### Data collection
####################
echo "> download the datasets"

if [ ! -d $WORK_DIR/data ]; then
    mkdir "$WORK_DIR/data"
fi 
if [ ! -d $WORK_DIR/data/raw ]; then 
    mkdir "$WORK_DIR/data/raw"
fi
if [ ! -d $WORK_DIR/data/raw/spades ]; then
    mkdir "$WORK_DIR/data/raw/spades"
fi

for file in $FILES; do # for loop iterates over a table
    if [ ! -f "$WORK_DIR/data/raw/spades/$file" ]; then 
        wget -P "$WORK_DIR/data/raw/spades/" "$SITE/$file"
    fi      
done 

