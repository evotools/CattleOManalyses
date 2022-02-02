#!/bin/bash
nsample=`awk 'BEGIN{n=0};{n+=1};END{print n}' $1`
svsize=$2
snpsift=/PATH/TO/snpEff

SCRIPT_DIR=`realpath $(dirname -- "${BASH_SOURCE[0]}")`
echo $SCRIPT_DIR

if [ ! -e FILTERS_${nsample}_${svsize} ]; then mkdir FILTERS_${nsample}_${svsize}; fi
for qual in 0 1 5 10 15 20; do
    if [ ! -e FILTERS_${nsample}_${svsize}/QUAL$qual ]; then mkdir FILTERS_${nsample}_${svsize}/QUAL$qual; fi
    if [ -e FILTERS_${nsample}_${svsize}/QUAL${qual}/filelist.txt ]; then rm FILTERS_${nsample}_${svsize}/QUAL${qual}/filelist.txt; fi
    while read vcf; do 
        vname=`basename -s .vcf.gz $vcf`
	vcftools --gzvcf $vcf --max-missing 1 --minQ $qual --stdout --recode --recode-INFO-all | \
		sed '/##fileDate/d' | \
		bcftools filter -i "SVLEN<-$svsize || SVLEN>$svsize" > FILTERS_${nsample}_${svsize}/QUAL${qual}/${vname}.filtQUAL${qual}.vcf
        echo FILTERS_${nsample}_${svsize}/QUAL${qual}/${vname}.filtQUAL${qual}.vcf
    done < $1 >> FILTERS_${nsample}_${svsize}/QUAL${qual}/filelist.txt
    for dist in 100 500 1000 1500 2000 2500 3000 3500 4000; do 
        if [ ! -e FILTERS_${nsample}_${svsize}/QUAL$qual/MAXDIST${dist} ]; then mkdir FILTERS_${nsample}_${svsize}/QUAL$qual/MAXDIST${dist}; fi
        echo "Distance "$dist
        SURVIVOR merge FILTERS_${nsample}_${svsize}/QUAL${qual}/filelist.txt $dist 1 1 0 1 1000 FILTERS_${nsample}_${svsize}/QUAL$qual/MAXDIST${dist}/Merged_minQ${qual}_maxDist${dist}.vcf
        echo
        cat FILTERS_${nsample}_${svsize}/QUAL$qual/MAXDIST${dist}/Merged_minQ${qual}_maxDist${dist}.vcf | vcf-sort | bgzip -c > FILTERS_${nsample}_${svsize}/QUAL$qual/MAXDIST${dist}/Merged_minQ${qual}_maxDist${dist}.vcf.gz && rm FILTERS_${nsample}_${svsize}/QUAL$qual/MAXDIST${dist}/Merged_minQ${qual}_maxDist${dist}.vcf
        tabix -p vcf FILTERS_${nsample}_${svsize}/QUAL$qual/MAXDIST${dist}/Merged_minQ${qual}_maxDist${dist}.vcf.gz
        bcftools query -f '%CHROM %POS %ID %SVLEN %SUPP_VEC\n' FILTERS_${nsample}_${svsize}/QUAL$qual/MAXDIST${dist}/Merged_minQ${qual}_maxDist${dist}.vcf.gz > FILTERS_${nsample}_${svsize}/QUAL$qual/MAXDIST${dist}/Merged_minQ${qual}_maxDist${dist}.suppvec
        zcat FILTERS_${nsample}_${svsize}/QUAL$qual/MAXDIST${dist}/Merged_minQ${qual}_maxDist${dist}.vcf.gz | awk '$1~"#CHROM"{print}' | cut -f 10- | tr '\t' '\n' > FILTERS_${nsample}_${svsize}/QUAL$qual/MAXDIST${dist}/Merged_minQ${qual}_maxDist${dist}.samples
    done
done
echo "Prepared the files; making plots now."
cd ./FILTERS_${nsample}_${svsize}
TZ="Europe/London" Rscript "${SCRIPT_DIR}/UpSetMultifolder.R" 
cd ../
echo "All done."
