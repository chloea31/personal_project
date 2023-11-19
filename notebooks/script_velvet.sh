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
WORK_DIR="$PWD" # working directory -> absolute way of the current (working) directory
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

mkdir -p $WORK_DIR/reports/QC/velvet # to create all folders recursively

# basename and without the extension
for file in $WORK_DIR/data/raw/velvet/*.fastq; do 
    fastq_file="$(basename -- $file)"
    if [[ ! -f $WORK_DIR/reports/QC/velvet/${fastq_file%.*} ]]; then
        fastqc ${fastq_file%.*} -o $WORK_DIR/reports/QC/velvet/
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
### Assemble reads with Velvet
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

for folder in $WORK_DIR/reports/assembly/velvet/test_k_mers*; do
    if [ ! -f $WORK_DIR/reports/assembly/velvet/$folder/contigs.fa ]; then
        cd $folder && velvetg .
        # does not change the global directory of the program (comes directly back to the main folder after 
        # running velvetg): only changes the folder for the velvetg command
        # &&: if the command on the left is successful, executes the command on the right
    fi
done 

# Datamash
echo ">run datamash"
#cat stats.txt | datamash -H mean 2
#cat stats.txt | datamash -H min 2
#cat stats.txt | datamash -H max 2

#####################
### Collect fasta statistics on the contigs
#####################

# Quast
echo "> run quast"

CONTIG_START=31
CONTIG_END=101
CONTIG_STEP=4

CONTIG_SEQ_COUNT=$(seq $CONTIG_START $CONTIG_STEP $CONTIG_END | wc -l) # gives the number of files we should have
CONTIG_FILE_COUNT=$(ls -l $WORK_DIR/reports/quast/velvet/contig_kmer_* | wc -l) 

for folder in $WORK_DIR/reports/assembly/velvet/test_k_mers*; do
#for contig_file in $WORK_DIR/reports/assembly/velvet/$folder/; do
    if [ $CONTIG_FILE_COUNT -ne $CONTIG_SEQ_COUNT ]; then
        /home/caujoulat/miniforge3/envs/EnvVelvet/bin/quast.py reports/assembly/velvet/$folder/contigs.fa \
            -o reports/quast/velvet/contig_kmer_$CONTIG_FILE_COUNT \
            -r data/raw/wildtype.fna \
            --contig-thresholds 0,1000
    fi
done

# By default, assume a prokaryotic genome 
# By default, we assume a lower threshold of 500 (lower threshold of contig length)

