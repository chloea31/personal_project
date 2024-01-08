#!/usr/bin/env nextflow

// conda activate EnvVelvet

// to run the pipeline: nextflow run script_velvet_nextflow.nf

// Declare synthax version
nextflow.enable.dsl=2 

// channels: allow processes to communicate between each other 

process downloadFiles {
    input:
        val file

    output:
        path './data/raw/velvet/*.fastq' 
        path './data/raw/velvet/*.fna'

    """
    wget -P ./data/raw/velvet/ https://zenodo.org/record/582600/files/$file 
    """
}

workflow {
    Channel.of("mutant_R1.fastq","mutant_R2.fastq","wildtype.fna") | downloadFiles | view
}

process interlacerFiles {
    input:
        val file

    output:
        path './data/interm/velvet/*.fastqsanger'

    """
    echo '>use the Galaxy website or try to find a command line to do it in the terminal'
    """
}

workflow {
    Channel.of() | interlacerFiles | view
}
