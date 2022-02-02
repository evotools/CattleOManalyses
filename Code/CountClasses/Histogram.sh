#!/bin/bash
# Input vcf to generate the histogram
invcf=$1

# Extract the necessary information
bcftools query -f '%CHROM\t%POS\t%ID\t%SVTYPE\t%SVLEN\n' $invcf > SVs_type_len.tsv

# Create the histogram
Rscript Histogram.R 
