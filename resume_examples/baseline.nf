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
  tag { input }
  publishDir params.dstDir, mode: 'copy'
    
  input:
  file input from inputfiles
  
  output:
  file "${input.getBaseName()}_one.txt" into onefiles     

  when:
  !file("${params.dstDir}/${input.getBaseName()}_one.txt").exists()
    
  script:
  """
  cp $input ${input.getBaseName()}_one.txt
  """
}

process two {
  tag { input }
  publishDir params.dstDir, mode: 'copy'

  input:
  file input from onefiles
  
  output:
  file "${twoInput}_two.txt" into twofiles
  
  when:
  !file("${params.dstDir}/${twoInput}_two.txt").exists()

  script:    
  twoInput = "$input".split("_")[0]
  """
  cp $input ${twoInput}_two.txt
  """
}

process three {
  tag { input }
  publishDir params.dstDir, mode: 'copy'

  input:
  file input from twofiles

  output:
  file "${threeInput}_three.txt" into threefiles

  when:
  !file("${params.dstDir}/${threeInput}_three.txt").exists()

  script:
  threeInput = "$input".split("_")[0]
  """
  cp $input ${threeInput}_three.txt
  """
}

