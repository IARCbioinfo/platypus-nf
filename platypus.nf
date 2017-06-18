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
    log.info "--platypus_path            PATH                Path to platypus. Default: Platypus.py"
    log.info "--region                   FILE or REGION      Bed file or region (e.g. chr1, chr1:0-1000)"
    log.info '--cpu                      INTEGER             Number of cpu used for parallel variant calling. Default: 1.'
    log.info '--mem                      INTEGER             Size of memory used, in GB. Default: 4.'
    log.info "--output_folder            FOLDER              Output VCF folder. Default: . "
    log.info '--options                  STRING              Options to pass to platypus (e.g. " --scThreshold=0.9 --qdThreshold=10 ") '
    log.info "                                               Caution: for --options, space between quotes and arguments are mandatory. "
    log.info ""
    log.info "Flags:"
    log.info "--optimized                                    Run platypus with optimized option based on WGS/WES of GIAB platinium"
    log.info ""
    exit 0

}

params.input_folder = null
params.output_folder = "."
params.platypus_path = "Platypus.py"
params.region = null

if (params.region){
  region_tag = "--region="
} else {
  region_tag = ""
}

ref = file(params.ref)
ref_fai = file( params.ref+'.fai' )
params.cpu = 1
params.mem = 4

params.optimized = false
if (params.optimized){
  opt_options = "--badReadsThreshold=0 --qdThreshold=0 --rmsmqThreshold=20 --hapScoreThreshold=10 --scThreshold=0.99"
} else {
  opt_options = ""
}

params.options = ""

bams = Channel.fromPath( params.input_folder+'/*.bam' )
              .ifEmpty { error "Cannot find any bam file in: ${params.input_folder}" }
              .map {  path -> [ path.name.replace(".bam",""), path ] }

bais = Channel.fromPath( params.input_folder+'/*.bam.bai' )
              .ifEmpty { error "Cannot find any bai file in: ${params.input_folder}" }
              .map { path -> [ path.name.replace(".bam.bai",""), path ] }

bam_bai = bams
          .phase(bais)
          .map { bam, bai -> [ bam[1], bai[1] ] }



process platypus {
  cpus params.cpu
  memory params.mem+'GB'

  tag { bam_tag }

  publishDir params.output_folder, mode: 'move', pattern: '*.vcf'

  input:
  file bam_bai
  file ref
  file ref_fai

  output:
  file '*vcf' into output_vcf

  shell:
  bam_tag = bam_bai[0].baseName
  '''
  !{params.platypus_path} callVariants --bamFiles=!{bam_tag}.bam --output=!{bam_tag}_platypus.vcf !{region_tag}!{params.region} --refFile=!{params.ref} !{opt_options} !{params.options}
  '''

}