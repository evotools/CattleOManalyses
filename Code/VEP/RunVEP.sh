#!/bin/bash

vcfname=$1
nthreads=$2

docker run -it -v $HOME/vep_data:/opt/vep/.vep ensemblorg/ensembl-vep:latest vep \
		-i /opt/vep/.vep/input/$vcfname \
		-o /opt/vep/.vep/output/stats \
		--fork $nthreads \
		--species bos_taurus \
		--variant_class \
		--sift b \
		--nearest symbol \
		--distance 200 \
		--offline \
		--cache /opt/vep/.vep/
