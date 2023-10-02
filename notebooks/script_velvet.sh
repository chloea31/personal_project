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

less mutant_R1.fastq
less mutant_R2.fastq
less wildtype.fna

# Quality control of the data
fastqc mutant_R1.fastq
fastqc mutant_R2.fastq

# MultiQC on FASTQ files
multiqc ../fastqc/*_fastqc.zip

##########
# Assemble reads with Velvet
##########

# 1) Interlacer tool:
# Use this link: https://usegalaxy.eu/root?tool_id=fastq_paired_end_interlacer

# 2) velveth
velveth ../reports/velvet/. 29 -shortPaired -fastq -interleaved ../data/interm/Galaxy5-\[FASTQ_interlacer_pairs_from_data_2_and_data_1\].fastqsanger
less Log
less Roadmaps
less Sequences

# 3) velvetg
velvetg .
less contigs.fa
wc -l stats.txt
tail -5 stats.txt
grep -o '>' contigs.fa | wc -l

##########
# Collect some statistics on the contigs
##########

# Datamash
cat stats.txt | datamash -H mean 2
cat stats.txt | datamash -H min 2
cat stats.txt | datamash -H max 2

# Quast
/home/caujoulat/miniconda3/envs/EnvVelvet/bin/quast.py ../reports/velvet/contigs.fa \
    -o ../reports/quast/. \
    -r ../data/raw/wildtype.fna \
    --contig-thresholds 0.1000


