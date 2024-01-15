#!/bin/bash

#######################################################################################################################################
#######################################################################################################################################
#*/                                            INTRODUCTION TO GENOME ASSEMBLY USING UNICYCLER                                      /*#
#######################################################################################################################################
#######################################################################################################################################


####################
### Activate the working environment
####################

conda activate EnvUnicycler

####################
### Running the pipeline
####################

# in /home/Documents/Bioinformatique/personal_project/ tape: ./notebooks/unicycler/script_unicycler.sh

####################
### Variable initialization
####################

SITE="https://zenodo.org/record/940733/files"
WORK_DIR=. # working directory
FILES="illumina_f.fq illumina_r.fq minion_2d.fq"
QUAST_DIR=/home/caujoulat/miniforge3/envs/EnvUnicycler/bin

####################
### Data collection
####################
echo "> download the datasets"

for file in $FILES; do # for loop iterates over a table
    if [ ! -f "$WORK_DIR/data/raw/unicycler/$file" ]; then 
        wget -P "$WORK_DIR/data/raw/unicycler/" "$SITE/$file"
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

# for file in $WORK_DIR/data/raw/unicycler/*.fq; do 
#     if [ ! -d $WORK_DIR/reports/unicycler/QC ]; then 
#         mkdir -p "$WORK_DIR/reports/unicycler/QC"
#     fi
#     fastqc $file -o "$WORK_DIR/reports/unicycler/QC/"
# done

# basename and without the extension
for file in $WORK_DIR/data/raw/unicycler/*.fq; do 
    fastq_file="$(basename $file | sed 's/\.fq/_fastqc/g')" 
    # takes the last part of the path, so the name of the FASTQ file
    html_file="$WORK_DIR/reports/unicycler/QC/$fastq_file.html" 
    # path of the HTML file which will be generated by FASTQC
    zip_file="$WORK_DIR/reports/unicycler/QC/$fastq_file.zip" 
    if [[ ! -f "$html_file" ]] || [[ ! -f "$zip_file" ]]; then # || : OR
        fastqc -o "$WORK_DIR/reports/unicycler/QC/" "$file"
        #echo "$file, $fastq_file, $html_file, $zip_file"
        #if [[ -f $html_file ]]; then echo "OK html"; else echo "None html"; fi
        #if [[ -f $zip_file ]]; then echo "OK zip"; else echo "None zip"; fi
    fi
done

# MultiQC on FASTQ files
echo "> run multiqc"

if [ ! -d $WORK_DIR/reports/unicycler/QC/multiQC ]; then 
    mkdir -p "$WORK_DIR/reports/unicycler/QC/multiQC"
fi
if [ ! -d $WORK_DIR/reports/unicycler/QC/multiQC/multiqc_data ]; then
    multiqc "$WORK_DIR/reports/unicycler/QC/*_fastqc.zip" -o "$WORK_DIR/reports/unicycler/QC/multiQC/multiqc_data"
fi

#################
### Assemble reads with Unicycler
#################
echo "> run unicycler"

# if [ ! -d $WORK_DIR/reports/assembly ]; then
#     mkdir $WORK_DIR/reports/assembly
# fi

# unicycler -1 $WORK_DIR/data/raw/illumina_f.fq \
#     -2 $WORK_DIR/data/raw/illumina_r.fq \
#     -l $WORK_DIR/data/raw/minion_2d.fq \
#     -o reports/assembly/ # hybrid assembly

# grep ">" assembly.fasta | wc -l

#################
### Assess Assembly quality with Quast
#################
echo "> run assembly quality with quast"

# if [ ! -d $WORK_DIR/reports/quast ]; then
#     mkdir $WORK_DIR/reports/quast
# fi

# $QUAST_DIR/quast.py -o $WORK_DIR/reports/quast/ $WORK_DIR/reports/assembly/assembly.fasta

#################
### Genome annotation using Prokka
#################
echo "> run prokka"

# prokka --outdir $WORK_DIR/reports/prokka \
#     --genus Escherichia \
#     --species coli \
#     --strain C-1 \
#     --usegenus \
#     $WORK_DIR/reports/assembly/assembly.fasta 
