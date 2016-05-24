#!/usr/bin/env nextflow

/* 
  This tests the behavior of publishDir outputting folders to buckets.
  Create a few txt files in the working folder before running this.
*/

params.bucket = "s3://nextflow-demo-output"

Channel
    .fromPath( "*.txt" ) 
    .set { copyfiles }

Channel
    .fromPath( "*.txt" )
    .set { movefiles }

process copytest {
    tag { sam }

    publishDir params.bucket + '/copy', mode: 'copy'
    
    input:
    file sam from copyfiles

    output:
    file out into copyresults

    script:
    out=sam.getBaseName()
    """
    mkdir "$out"
    touch "${out}/result1.txt"
    touch "${out}/result2.txt"
    touch "${out}/result3.txt"
    """
}

process movetest {
    tag { sam }

    publishDir params.bucket + '/move', mode: 'move'

    input:
    file sam from movefiles

    output:
    file out into copyresults

    script:
    out=sam.getBaseName()
    """
    mkdir "$out"
    touch "${out}/result1.txt"
    touch "${out}/result2.txt"
    touch "${out}/result3.txt"
    """
}

