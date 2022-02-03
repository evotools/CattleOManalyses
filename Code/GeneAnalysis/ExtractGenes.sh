#!/bin/bash
vcf=$1
annotation=$2

# Extract CDSs
awk '$3=="CDS" {print}' ${annotation} > ANNOT/CDS.gff3
awk '$3=="gene" {print}' ${annotation} > ANNOT/GENES.gff3

# Extract unique SVs in a CDS (SVxCDS)
bedtools intersect -a $vcf -b ANNOT/CDS.gff3 -u | awk 'BEGIN{n=0};{n+=1};END{print "INITIAL", n}' > ANNOT/overlap_CDS.txt

# Extract unique CDS overlapping an SV (CDSxSV)
bedtools intersect -a ANNOT/CDS.gff3 -b $vcf -u > ANNOT/CDS_with_SV.gff

# Extract the unique genes overlapping the CDSxSV
bedtools intersect -a ANNOT/GENES.gff3 -b ANNOT/CDS_with_SV.gff -u > ANNOT/GENES_with_SV.gff

# Extract the gene IDs and names
cut -f 9- ANNOT/GENES_with_SV.gff | awk 'BEGIN{FS=";"; OFS="\t"}; {print $1}' | sed 's/ID=gene://g' | sort | uniq > ANNOT/GENEID_with_SV.tsv
cut -f 9- ANNOT/GENES_with_SV.gff | awk 'BEGIN{FS=";"; OFS="\t"}; $2~"Name" {print $2}' | sed 's/Name=//g' | sort | uniq > ANNOT/GENENAME_with_SV.tsv
