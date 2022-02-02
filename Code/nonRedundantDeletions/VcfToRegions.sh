#!/bin/bash

# Extract the regions affected by deletions in each sample
if [ ! -e BED_DEL ] ; then mkdir BED_DEL; fi
while read p; do
	bcftools query -f '%CHROM\t%POS\t%END\t%SVLEN\t%ID\t%CIPOS\t%CIEND\n' $p | \
		python -c 'import sys; lines = [line.strip().split() for line in sys.stdin]; lines = [l + list(map(int, [l[-2].split(",")[1], l[-1].split(",")[0]])) for l in lines]; lines = [ "\t".join(list(map(str, l + [int(l[1]) + l[-2], int(l[2]) + l[-1], int(( int(l[1]) + l[-2] + int(l[2]) + l[-1] ) / 2) ]))) for l in lines ]; print("\n".join(lines))' | \
		awk '$4<0{OFS="\t"; print $1, $NF + int($4/2), $NF - int($4/2), "ID="$5"#CENTER="$NF"#POS_INNER="$(NF-2)"#END_INNER="$(NF-1)"#SVLEN"$4}' > ./BED_DEL/`basename $p $2`.bed
done < $1

# Combine all bed files and merge them
cat ./BED_DEL/*.bed | bedtools sort -i - | bedtools merge -i - > non_redundant_deleted_regions.bed

