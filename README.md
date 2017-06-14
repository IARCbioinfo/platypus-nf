# Platypus-nf
## Germline variant calling with platypus

![Workflow representation](template-nf.png)

## Description
Perform germlne variant calling with platypus, with optional use of optimized parameters based on performance analysis on [Illumina Platinium Genome](https://www.illumina.com/platinumgenomes.html) (both whole exome/genome sequencing).

## Dependencies

1. This pipeline is based on [nextflow](https://www.nextflow.io). As we have several nextflow pipelines, we have centralized the common information in the [IARC-nf](https://github.com/IARCbioinfo/IARC-nf) repository. Please read it carefully as it contains essential information for the installation, basic usage and configuration of nextflow and our pipelines.

2. Platypus
See official installation [here](https://github.com/andyrimmer/Platypus).

You can avoid installing all the external software by only installing Docker. See the [IARC-nf](https://github.com/IARCbioinfo/IARC-nf) repository for more information.


## Input
  | Type      | Description     |
  |-----------|---------------|
  | --input_folder | Folder containing BAM files  |
  | --ref | Path fo fasta reference  |

## Parameters

  * #### Optional
  | Name             | Example value               | Description  |
  |------------------|-----------------------------|--------------|
  | --platypus_path  | /usr/bin/Platypus.py        | path to platypus executable |
  | --region         | chr1;chr1:0-1000; mybed.bed | region to call |
  | --cpu            |            12 | number of cpu used by platypus |
  | --mem            |            8 | memory in GB used by platypus |
  | --output_folder  |            . | folder to store output vcfs |
  | --options        | " --scThreshold=0.9 --qdThreshold=10 " | options to pass to platypus |


  * #### Flags

Flags are special parameters without value.

| Name      | Description     |
|-----------|-----------------|
| --help    | Display help |
| --optimized    |  use optimized parameters :  |
|     |  --badReadsThreshold=0 --qdThreshold=0 --rmsmqThreshold=20 --hapScoreThreshold=10 --scThreshold=0.99 |

## Usage
  ```
  nextflow run platypus.nf --input_folder ~/data_test/BAM/ --ref ~/data_test/17.fasta
  ```

## Output
  | Type      | Description     |
  |-----------|---------------|
  | VCFs    | one VCF by input BAM |

## Directed Acyclic Graph


## Contributions

  | Name      | Email | Description     |
  |-----------|---------------|-----------------|
  | Tiffany Delhomme*    | delhommet@students.iarc.fr | Developer to contact for support (link to specific gitter chatroom)
