#!/usr/bin/env nextflow

// conda activate EnvVelvet

// to run the pipeline: nextflow run script_velvet_nextflow.nf

// Declare synthax version
nextflow.enable.dsl=2 

// channels: allow processes to communicate between each other

// Reproducibility:
// - 1 folder/assembly
// - R1 and R2 for assembly; between 2 assemblies, R1 and R2 might not be at the same place
// - 3 parameters per assembly: species name, url R1 and url R2
// When we run the pipeline, we create the folder for the specie and we download the files inside this folder,
// then we would do the assembly inside this folder

process downloadFiles {
    input:
        tuple val(species), val(R1), val(R2)

    output:
        path "${species}" 
        path "${species}/data/raw/velvet/R1.fastq" 
        path "${species}/data/raw/velvet/R2.fastq"

    script:
    """
    mkdir -p $species/data/raw/velvet/
    wget -O $species/data/raw/velvet/R1.fastq $R1
    wget -O $species/data/raw/velvet/R2.fastq $R2  
    """
}

workflow {
    Channel.of(
        ["staphyloccocus_aureus",
         "https://zenodo.org/record/582600/files/mutant_R1.fastq",
         "https://zenodo.org/record/582600/files/mutant_R2.fastq"]
    ) | downloadFiles
}

process interlacerFiles {
    input:
        tuple val(species), val(R1), val(R2)

    output:
        path "${species}"
        path "${species}/data/interm/velvet/*.fastqsanger"

    """
    mkdir -p $species/data/interm/velvet/
    echo '>use the Galaxy website or try to find a command line to do it in the terminal'
    """
}

workflow {
    Channel.of() | interlacerFiles
}

