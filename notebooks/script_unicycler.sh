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

# in /home/Documents/Bioinformatique/personal_project/ tape: ./notebooks/script_unicycler.sh

####################
### Variable initialization
####################

SITE="https://zenodo.org/record/940733/files"
WORK_DIR=. # working directory
FILES="illumina_f.fq illumina_r.fq minion_2d.fq"
QUAST_DIR=/home/caujoulat/miniforge3/envs/EnvVelvet/bin

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

#du -sh *

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
echo "> run multiqc"

multiqc ../fastqc/*_fastqc.zip

#################
### Assemble reads with Unicycler
#################
echo "> run unicycler"

if [ ! -d $WORK_DIR/reports/assembly ]; then
    mkdir $WORK_DIR/reports/assembly
fi

unicycler -1 $WORK_DIR/data/raw/illumina_f.fq \
    -2 $WORK_DIR/data/raw/illumina_r.fq \
    -l $WORK_DIR/data/raw/minion_2d.fq \
    -o reports/assembly/ # hybrid assembly

grep ">" assembly.fasta | wc -l

#################
### Assess Assembly quality with Quast
#################
echo "run assembly quality with quast"

if [ ! -d $WORK_DIR/reports/quast ]; then
    mkdir $WORK_DIR/reports/quast
fi

$QUAST_DIR/quast.py -o $WORK_DIR/reports/quast/ $WORK_DIR/reports/assembly/assembly.fasta

#################
### Genome annotation using Prokka
#################
echo "> run prokka"

prokka --outdir $WORK_DIR/reports/prokka \
    --genus Escherichia \
    --species coli \
    --strain C-1 \
    --usegenus \
    $WORK_DIR/reports/assembly/assembly.fasta 
