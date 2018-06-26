From:biocontainers/biocontainers:v1.0.0_cv4
Bootstrap:docker

%labels
    MAINTAINER Tiffany Delhomme <delhommet@students.iarc.fr>
    DESCRIPTION Container image containing requirements for iarcbioinfo/platypus-nf pipeline
    VERSION 1.0

%environment
    PATH=/opt/conda/envs/platypus-nf/bin:$PATH
    export PATH

%files
    environment.yml /

%post
    /opt/conda/bin/conda env create -f /environment.yml
    /opt/conda/bin/conda clean -a
