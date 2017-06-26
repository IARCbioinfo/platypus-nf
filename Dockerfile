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
	git \ #to clone a github repo
	python \ #to run platypus
	wget \ #to download dependencies
	bzip2 \ #to extract repo
	ca-certificates \ #for wget a github repo
	zlib1g-dev \ #to install htslib
	libbz2-dev \ #to install htslib
	Cython && \ # for platypus make

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

