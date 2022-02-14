#!/bin/bash

invcf=$1
oname=$( basename `basename ACCESS_FLT/FILTERS_18_1000/Merged_minQ20_maxDist1000.vcf '.gz'` '.vcf' )
fname=$( basedir `realpath $1` )

bcftools query -f '%CHROM\t%POS\t%ID\t%SUPP\t%SVLEN\n' $invcf > ${fname}/${oname}.suppBySize
Rscript T-test_sizes.R ${fname}/${oname}.suppBySize ${fname} > t-statistics.out

# Check for gene elements
bcftools view -i 'INFO/SUPP==1' $invcf > ${fname}/${oname}.suppEq1.vcf
bcftools view -i 'INFO/SUPP>1' $invcf > ${fname}/${oname}.suppGt1.vcf

# Overlap genes
bedtools intersect -a ${fname}/${oname}.suppEq1.vcf -b ANNOT/CDS.gff3 -u | awk 'BEGIN{n=0};{n+=1};END{print "incds", "SUPPeq1", n}' > ${fname}/${oname}.overlap_CDS.txt
bedtools intersect -a ${fname}/${oname}.suppGt1.vcf -b ANNOT/CDS.gff3 -u | awk 'BEGIN{n=0};{n+=1};END{print "incds", "SUPPgt1", n}' >> ${fname}/${oname}.overlap_CDS.txt
bedtools intersect -a ${fname}/${oname}.suppEq1.vcf -b ANNOT/CDS.gff3 -v | awk 'BEGIN{n=0};{n+=1};END{print "outcds", "SUPPeq1", n}' >> ${fname}/${oname}.overlap_CDS.txt
bedtools intersect -a ${fname}/${oname}.suppGt1.vcf -b ANNOT/CDS.gff3 -v | awk 'BEGIN{n=0};{n+=1};END{print "outcds", "SUPPgt1", n}' >> ${fname}/${oname}.overlap_CDS.txt

Rscript FisherTest.R ${fname}/${oname}.overlap_CDS.txt > fisherStatistics.out
