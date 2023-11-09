#!/usr/bin/env nextflow

// conda activate EnvVelvet

// to run the pipeline: nextflow run script_velvet_nextflow.nf

// Declare synthax version
nextflow.enable.dsl=2 

// Parameters
myFileChannel = Channel.fromPath( '/data/raw/*' )

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

process downloadFiles {
    input:
        val(file)

    output:
        echo $file

    script:
    """
    wget https://zenodo.org/record/582600/files/$file
    """
}

workflow {
    channel.of
}
