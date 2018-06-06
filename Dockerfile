################## BASE IMAGE ######################
FROM biocontainers/biocontainers:v1.0.0_cv4

################## METADATA ######################

LABEL base_image="biocontainers:latest"
LABEL version="1.0"
LABEL software="platypus-nf"
LABEL software.version="1.0"
LABEL about.summary="Platypus germline variant calling with nextflow"
LABEL about.home="http://github.com/IARCbioinfo/platypus-nf"
LABEL about.documentation="http://github.com/IARCbioinfo/platypus-nf"
LABEL about.license_file="http://github.com/IARCbioinfo/platypus-nf"
LABEL about.license="GNU-3.0"

################## MAINTAINER ######################
MAINTAINER Tiffany Delhomme <delhommet@students.iarc.fr>

################## INSTALLATION ######################

RUN conda install platypus-variant
