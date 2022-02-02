#!/bin/bash
# Input parameters
solve_path=$1
molecules=$2
ref=$3

# Prepare reference
cp $ref ./solve_reference.fa
perl ${solve_path}/Pipeline/10252018/fa2cmap_multi_color.pl -i solve_reference.fa -e DLE1 1 

# Prefilter the reads
perl ${solve_path}/Pipeline/10252018/filter_SNR_dynamic.pl -i $molecules -o filtered.bnx

# Run the workflow
python ${solve_path}/Pipeline/10252018/pipelineCL.py -T 8 -j 8 -N 4 -f 0.2 -i 5 -y \
        -b filtered.bnx \
        -l output \
        -t ${solve_path}/RefAligner/7915.7989rel \
        -a ${solve_path}/RefAligner/7915.7989rel/optArguments_haplotype_DLE1_saphyr.xml \
        -r solve_reference.softMask_DLE1_0kb_0labels.cmap \
        -C ../clusterConf_custom_V2.xml 
