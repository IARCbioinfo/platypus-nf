# Set the base image to Debian
FROM debian:jessie

# File Author / Maintainer
MAINTAINER Tiffany Delhomme <delhommet@students.iarc.fr>

RUN mkdir -p /var/cache/apt/archives/partial && \
	touch /var/cache/apt/archives/lock && \
	chmod 640 /var/cache/apt/archives/lock && \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F76221572C52609D && \
	apt-get clean && \
	apt-get update -y && \

	# Install dependences
	DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
	make \
	gcc \
  #to clone a github repo
	git \
	#to run platypus
	python \
	#to download dependencies
	wget \
	#to extract repo
	bzip2 \
	#for wget a github repo
	ca-certificates \
	#to install htslib
	zlib1g-dev \
	#to install htslib
	libbz2-dev \
	liblzma-dev \
	# for platypus make
	python-dev \
	libxml2-dev \
	libxslt-dev \
	Cython && \

	# Install htslib required by platypus
	wget https://github.com/samtools/htslib/releases/download/1.4.1/htslib-1.4.1.tar.bz2 && \
	tar -jxf htslib-1.4.1.tar.bz2 && \
	cd htslib-1.4.1 && \
	make && \
	make install && \
	cd .. && \
	rm -rf htslib-1.4.1 htslib-1.4.1.tar.bz2 && \

	# Install manually last version of platypus from github
	git clone git://github.com/andyrimmer/Platypus.git && \
	cd Platypus && \
	make
  chmod +x bin/Platypus.py
