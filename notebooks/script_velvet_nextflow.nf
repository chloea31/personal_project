#!/usr/bin/env nextflow

// conda activate EnvVelvet

// to run the pipeline: nextflow run script_velvet_nextflow.nf

nextflow.enable.dsl=2 

process sayHello {
    input:
        val cheers
    output:
        stdout

    """
    echo $cheers
    """
}

workflow {
    channel.of('Ciao', 'Hello', 'Hola') | sayHello | view
}


