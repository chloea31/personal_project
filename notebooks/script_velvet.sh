#!/bin/bash

#######################################################################################################################################################
#######################################################################################################################################################
#*/                                                   INTRODUCTION TO GENOME ASSEMBLY USING VELVET                                                  /*#
#######################################################################################################################################################
#######################################################################################################################################################

####################
### Activate the working environment
####################

#conda activate EnvVelvet

####################
### Running the pipeline
####################

# in /home/Documents/Bioinformatique/personal_project/ tape: ./notebooks/script_velvet.sh

####################
### Variable initialization
####################

SITE="https://zenodo.org/record/582600/files"
WORK_DIR=. # working directory
FILES="mutant_R1.fastq mutant_R2.fastq wildtype.fna"
#QUAST_DIR=/home/caujoulat/miniforge3/envs/EnvVelvet/bin

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
if [ ! -d $WORK_DIR/data/raw/velvet ]; then
    mkdir $WORK_DIR/data/raw/velvet
fi

for file in $FILES; do # for loop iterates over a table
    if [ ! -f $WORK_DIR/data/raw/velvet/$file ]; then 
        wget -P $WORK_DIR/data/raw/velvet/ $SITE/$file
    fi      
done 

#wget https://zenodo.org/record/582600/files/mutant_R1.fastq
#wget https://zenodo.org/record/582600/files/mutant_R2.fastq
#wget https://zenodo.org/record/582600/files/wildtype.fna

####################
### Quality control of the data
####################
echo "> quality control of the data"

# basename and without the extension
for file in $WORK_DIR/data/raw/velvet/*.fastq; do 
    if [[ ! -f $WORK_DIR/reports/QC/velvet/${file}_fastqc.zip ]]; then
        mkdir -p $WORK_DIR/reports/QC/velvet # to create all folders recursively
        fastqc $file -o $WORK_DIR/reports/QC/velvet/
    fi
done

#fastqc mutant_R1.fastq
#fastqc mutant_R2.fastq

##################
### MultiQC on FASTQ files
##################
echo "> run the multiQC"

mkdir -p $WORK_DIR/reports/QC/velvet/multiQC

if [ ! -d $WORK_DIR/reports/QC/velvet/multiQC/multiqc_data ]; then
    multiqc $WORK_DIR/reports/QC/velvet/*_fastqc.zip -o $WORK_DIR/reports/QC/velvet/multiQC
fi

####################
# Assemble reads with Velvet
####################
echo "> genome assembly"

mkdir -p $WORK_DIR/data/interm/velvet

# 1) Interlacer tool:
# Use this link: https://usegalaxy.eu/root?tool_id=fastq_paired_end_interlacer

# 2) velveth
echo ">run velveth"
#velveth ../reports/velvet/. 29 -shortPaired -fastq -interleaved ../data/interm/velvet/fastq_interlacer_PE.fastqsanger
#less Log
#less Roadmaps
#less Sequences

mkdir -p $WORK_DIR/reports/assembly/velvet/test_k_mers

START=31
END=101
STEP=4

SEQ_COUNT=$(seq $START $STEP $END | wc -l) # gives the number of files we should have
FILE_COUNT=$(ls -l $WORK_DIR/reports/assembly/velvet/test_k_mers_* | wc -l) # we do not count the test_kmers we created previously

if [ $FILE_COUNT -ne $SEQ_COUNT ]; then 
    velveth $WORK_DIR/reports/assembly/velvet/test_k_mers $START,$END,$STEP -shortPaired -fastq -interleaved \
        $WORK_DIR/data/interm/velvet/fastq_interlacer_PE.fastqsanger
fi 

# 3) velvetg
echo "> run velvetg"
#velvetg .
#less contigs.fa
#wc -l stats.txt
#tail -5 stats.txt
#grep -o '>' contigs.fa | wc -l

##########
# Collect some statistics on the contigs
##########

# Datamash
echo ">run datamash"
#cat stats.txt | datamash -H mean 2
#cat stats.txt | datamash -H min 2
#cat stats.txt | datamash -H max 2

# Quast
echo "> run quast"
#/home/caujoulat/miniconda3/envs/EnvVelvet/bin/quast.py ../reports/velvet/contigs.fa \
 #   -o ../reports/quast/. \
 #   -r ../data/raw/wildtype.fna \
 #   --contig-thresholds 0.1000


