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