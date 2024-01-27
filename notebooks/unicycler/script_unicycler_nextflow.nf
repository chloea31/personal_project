#!/usr/bin/env nextflow

// conda activate EnvUnicycler

// to run the pipeline: nextflow run script_unicycler_nextflow.nf

// Declare synthax version
nextflow.enable.dsl=2 

// channels: allow processes to communicate between each other

// Reproducibility:

process downloadFiles {
    input: // choose its name, not its value
        tuple val(species), val(illumina_f), val(illumina_r), val(minion_2d)

    output: // choose its value, not its name, as return in a function in Python
        path "${species}" 
        path "${species}/data/raw/unicycler/illumina_f.fq" 
        path "${species}/data/raw/unicycler/illumina_r.fq"
        path "${species}/data/raw/unicycler/minion_2d.fq"

    script:
    """
    mkdir -p $species/data/raw/unicycler/
    wget -O $species/data/raw/unicycler/illumina_f.fq $illumina_f  
    wget -O $species/data/raw/unicycler/illumina_r.fq $illumina_r
    wget -O $species/data/raw/unicycler/minion_2d.fq $minion_2d  
    """
}
// -O option to download a file and mention a specific name

process unicyclerAssembly {
    input:
        path species // convenient with the first process
        path illumina_f // define the names of the inputs, so no whole path here
        path illumina_r
        path minion_2d

    output:
        path "${species}/reports/unicycler/assembly"

    script:
    """
    mkdir -p $species/reports/unicycler/assembly/
    unicycler -1 $illumina_f -2 $illumina_r -l $minion_2d -o ${species}/reports/unicycler/assembly/
    """
}

process assemblyQualityQuast {
    input:
        path species
        path assembly
        path quast

    output:
        path "${species}/reports/unicycler/quast"

    script:
    """
    mkdir -p $species/reports/unicycler/quast/
    $quast/quast.py -o $species/reports/unicycler/quast/ $assembly/assembly.fasta
    """
}

workflow {
    Channel.of(
        ["e.coli",
         "https://zenodo.org/record/940733/files/illumina_f.fq",
         "https://zenodo.org/record/940733/files/illumina_r.fq",
         "https://zenodo.org/record/940733/files/minion_2d.fq"]
    ) | downloadFiles | unicyclerAssembly | assemblyQualityQuast
}
// the workflow defines the different steps of the pipeline


