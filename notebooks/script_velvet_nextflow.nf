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


