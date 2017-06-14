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
  | --ref | Folder containing BAM files  |

## Parameters

  * #### Mandatory
  | Name      | Example value | Description     |
  |-----------|---------------|-----------------|
  | --param1    |            xx | ...... |
  | --param2    |            xx | ...... |

  * #### Optional
| Name      | Default value | Description     |
|-----------|---------------|-----------------|
| --param3   |            xx | ...... |
| --param4    |            xx | ...... |

  * #### Flags

Flags are special parameters without value.

| Name      | Description     |
|-----------|-----------------|
| --help    | Display help |
| --flag2    |      .... |


## Usage
  ```
  ...
  ```

## Output
  | Type      | Description     |
  |-----------|---------------|
  | output1    | ...... |
  | output2    | ...... |


## Detailed description (optional section)
...

## Directed Acyclic Graph


## Contributions

  | Name      | Email | Description     |
  |-----------|---------------|-----------------|
  | contrib1*    |            xx | Developer to contact for support (link to specific gitter chatroom) |
  | contrib2    |            xx | Developer |
  | contrib3    |            xx | Tester |

## References (optional)

## FAQ (optional)
