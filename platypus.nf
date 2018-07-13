#! /usr/bin/env nextflow

//vim: syntax=groovy -*- mode: groovy;-*-

// Copyright (C) 2017 IARC/WHO

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

params.help = null

log.info ""
log.info "-----------------------------------------------------------------------------------------"
log.info "                     PLATYPUS: EFFICIENT GERMLINE VARIANT CALLING                        "
log.info "-----------------------------------------------------------------------------------------"
log.info "Copyright (C) IARC/WHO"
log.info "This program comes with ABSOLUTELY NO WARRANTY; for details see LICENSE"
log.info "This is free software, and you are welcome to redistribute it"
log.info "under certain conditions; see LICENSE for details."
log.info "------------------------------------------------------------------------------------------"
log.info ""

if (params.help) {

    log.info "--------------------------------------------------------------------------------------"
    log.info "                                      USAGE                                           "
    log.info "--------------------------------------------------------------------------------------"
    log.info ""
    log.info "nextflow run iarcbioinfo/platypus-nf [-with-docker] [OPTIONS]"
    log.info ""
    log.info "Mandatory arguments:"
    log.info "--input_folder             FOLDER              Input folder containing BAM files."
    log.info "--ref                      FASTA               Path to fasta reference."
    log.info ""
    log.info "Optional arguments:"
    log.info "--platypus_bin             PATH                Path to platypus. Default: Platypus.py"
    log.info "--region                   FILE or REGION      Bed file or region (e.g. chr1, chr1:0-1000)"
    log.info '--cpu                      INTEGER             Number of cpu used for parallel variant calling. Default: 1.'
    log.info '--mem                      INTEGER             Size of memory used, in GB. Default: 4.'
    log.info "--output_folder            FOLDER              Output VCF folder. Default: . "
    log.info '--options                  STRING              Options to pass to platypus (e.g. " --scThreshold=0.9 --qdThreshold=10 ") '
    log.info "                                               Caution: for --options, space between quotes and arguments are mandatory. "
    log.info ""
    log.info "Flags:"
    log.info "--optimized                                    Run platypus with optimized option based on WGS/WES of Illumina platinium genomes."
    log.info "--compression                                  Compress and index the VCF (bgzip/tabix)."
    log.info "--filter                                       Filter platypus variant calls on PASS."
    log.info ""
    exit 0

}

params.filter = null
params.compression = null
params.input_folder = null
params.output_folder = "."
params.platypus_bin = "platypus"
params.region = "no_input_region"

region = file(params.region)
ref = file(params.ref)
ref_fai = file( params.ref+'.fai' )
params.cpu = 1
params.mem = 4

params.optimized = ""
opt_options = "--badReadsThreshold=0 --qdThreshold=0 --rmsmqThreshold=20 --hapScoreThreshold=10 --scThreshold=0.99"
params.options = ""

bams = Channel.fromPath( params.input_folder+'/*.bam' )
              .ifEmpty { error "Cannot find any bam file in: ${params.input_folder}" }
              .map {  path -> [ path.name.replace(".bam",""), path ] }

bais = Channel.fromPath( params.input_folder+'/*.bai' )
              .ifEmpty { error "Cannot find any bai file in: ${params.input_folder}" }
              .map { path -> [ path.name.replace('.bai','').replace('.bam',''), path ] }

bam_bai = bams
          .phase(bais)
          .map { bam, bai -> [ bam[1], bai[1] ] }



process platypus {
  cpus params.cpu
  memory params.mem+'GB'

  tag { bam_tag }

  if(params.compression == null & params.filter == null){
    publishDir params.output_folder, mode: 'move', pattern: '*.vcf'
  }

  input:
  file bam_bai
  file ref
  file ref_fai
  file region

  output:
  file '*vcf' into platypus_vcf_to_filter mode flatten

  shell:
  region_arg = region.name == "no_input_region" ? "" : "--region=${region}"
  options_arg = "${params.optimized}" == "" ? "${params.options}" : "${opt_options}"
  bam_tag = bam_bai[0].baseName
  '''
  !{params.platypus_bin} callVariants --nCPU=!{params.cpu} --bamFiles=!{bam_tag}.bam --output=file.vcf !{region_arg} --refFile=!{ref} !{options_arg}
  sed 's/^##FORMAT=<ID=NV,Number=.,/##FORMAT=<ID=NV,Number=A,/1g' file.vcf | sed 's/^##FORMAT=<ID=NR,Number=.,/##FORMAT=<ID=NR,Number=A,/1g' > !{bam_tag}_platypus.vcf
  rm file.vcf
  '''

}

if(params.filter){

  process filter_on_pass {

    tag { vcf_tag }

    if(params.compression == null){
      publishDir params.output_folder, mode: 'move', pattern: '*.vcf'
    }

    input:
    file platypus_vcf_to_filter

    output:
    file("${vcf_tag}.vcf") into platypus_vcf mode flatten

    shell:
    vcf_tag = platypus_vcf_to_filter.baseName.replace("_platypus.vcf","")
    '''
    grep "^#" !{vcf_tag}.vcf > output
    grep -v "^#" !{vcf_tag}.vcf | grep "PASS" >> output
    rm !{vcf_tag}.vcf
    mv output !{vcf_tag}.vcf
    '''
  }

} else {

  platypus_vcf = platypus_vcf_to_filter

}

if(params.compression){

  process bgziptabix {

    tag { vcf_tag }

    publishDir params.output_folder, mode: 'move', pattern: '*.vcf.gz*'

    input:
    file platypus_vcf
    file ref
    file ref_fai

    output:
    file("${vcf_tag}.vcf.gz*") into compressed_VCF

    shell:
    vcf_tag = platypus_vcf.baseName.replace("_platypus.vcf","")
    '''
    bgzip -c !{vcf_tag}.vcf > !{vcf_tag}.vcf.gz
    tabix -p vcf !{vcf_tag}.vcf.gz
    '''
  }

}
