#!/usr/bin/env nextflow

// Baseline example of processes. Everything is supposed to work right
// in this one.

params.srcDir = 'in'
params.dstDir = 'out'

//create the test cases
new File(params.srcDir + "/moe.txt").createNewFile()  
new File(params.srcDir + "/curly.txt").createNewFile()  
new File(params.srcDir + "/larry.txt").createNewFile()  

Channel
  .fromPath( "${params.srcDir}/*.txt" )                                     
  .ifEmpty { error "Cannot find any reads matching: ${params.srcDir}" }  
  .set { inputfiles }
  
process one {
  publishDir params.dstDir  
    
  input:
  file input from inputfiles
  
  output:
  file "${input.getBaseName()}_one.txt" into onefiles     

  when:
  !file("${input.getBaseName()}_one.txt").exists()
    
  script:
  log.info "process one file $input"
  """
  cp $input "${input.getBaseName()}_one.txt"
  """
}

process two {
  publishDir params.dstDir  

  input:
  file input from onefiles
  
  output:
  file into twofiles
  
  when:
  !file("${twoInput}_two.txt").exists()

  script:    
  twoInput = input.split("_")[0]
  log.info "process two file $input"
  """
  cp $twoInput "${twoInput}_two.txt"
  """
}

process three {
  publishDir params.dstDir  

  input:
  file input from twofiles
  
  output:
  file into threefiles
  
  when:
  !file("${threeInput}_three.txt").exists()

  scripts:
  threeInput = input.split("_")[0]
  log.info "process three file $input"
  """
  cp $threeInput "${threeInput}_three.txt"
  """  
}