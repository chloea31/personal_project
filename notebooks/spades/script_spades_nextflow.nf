#!/usr/bin/env nextflow

// conda activate EnvSPAdes

// to run the pipeline: nextflow run script_spades_nextflow.nf

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
        path "${species}/data/raw/spades/R1.fastq" 
        path "${species}/data/raw/spades/R2.fastq"

    script:
    """
    mkdir -p $species/data/raw/spades/
    wget -O $species/data/raw/spades/R1.fastq $R1  
    wget -O $species/data/raw/spades/R2.fastq $R2  
    """
}
// -O option to download a file and mention a specific name

process fastQC {
    input:
        path species // convenient with the first process
        path R1 // define the names of the inputs, so no whole path here
        path R2

    output:
        path "${species}/reports/spades/QC"

    script:
    """
    mkdir -p ${species}/reports/spades/QC/
    fastqc -o ${species}/reports/spades/QC/ $R1
    fastqc -o ${species}/reports/spades/QC/ $R2
    """
}

process multiQC {
    input:
        path QC // convenient with the first process

    output:
        path "${QC}/multiQC"

    script:
    """
    mkdir -p ${QC}/multiQC/
    multiqc ${QC} -o ${QC}/multiQC/multiqc_data
    """
}

process SPAdesAssembly {
    input:
        path species // convenient with the first process
        path R1 // define the names of the inputs, so no whole path here
        path R2

    output:
        path "${species}"
        path "${species}/reports/spades/assembly"

    script:
    """
    mkdir -p ${species}/reports/spades/assembly/
    spades.py -1 ${species}/data/raw/spades/${R1} -2 ${species}/data/raw/spades/${R2} \
        --careful \
        --cov-cutoff auto \
        -o ${species}/reports/spades/assembly/
    """
}

process assemblyQualityQuast {
    input:
        path species
        path assembly

    output:
        path "${species}/reports/spades/quast"

    script:
    """
    mkdir -p $species/reports/spades/quast/
    quast -o $species/reports/spades/quast/ $assembly/scaffolds.fasta
    """
}

process annotationProkka {
    input:
        path species
        path assembly

    output:
        path "$species/reports/spades/prokka"

    script:
    """
    prokka --outdir $species/reports/spades/prokka --genus Escherichia --species coli --strain C-1 --usegenus $assembly/scaffolds.fasta 
    """
}

workflow {
    Channel.of(
        ["staphyloccocus_aureus",
         "https://zenodo.org/record/582600/files/mutant_R1.fastq",
         "https://zenodo.org/record/582600/files/mutant_R2.fastq"]
    )
    (species, R1, R2) = downloadFiles(data) 
    QC = fastQC(species, R1, R2)
    multiqc_data = multiQC(QC)
    (species, assembly) = SPAdesAssembly(species, R1, R2) 
    quast = assemblyQualityQuast(species, assembly) 
    prokka = annotationProkka(species, assembly)
}
// the workflow defines the different steps of the pipeline
