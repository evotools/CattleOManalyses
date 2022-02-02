#!/bin/bash

if [ -e classes.txt ]; then rm classes.txt; fi

# Characterise ins
bcftools view -i 'SVTYPE=="INS" & SVLEN>=5000 & SVLEN<10000' ACCESS_FLT/FILTERS_18_1000/QUAL20/MAXDIST1000/Merged_minQ20_maxDist1000.vcf.gz | bcftools stats | grep "number of records:" | awk '{print "INS", "5000-4999",$NF}' >> classes.txt
bcftools view -i 'SVTYPE=="INS" & SVLEN>=10000 & SVLEN<15000' ACCESS_FLT/FILTERS_18_1000/QUAL20/MAXDIST1000/Merged_minQ20_maxDist1000.vcf.gz | bcftools stats | grep "number of records:" | awk '{print "INS", "10000-14999",$NF}' >> classes.txt
bcftools view -i 'SVTYPE=="INS" & SVLEN>=15000 & SVLEN<20000' ACCESS_FLT/FILTERS_18_1000/QUAL20/MAXDIST1000/Merged_minQ20_maxDist1000.vcf.gz | bcftools stats | grep "number of records:" | awk '{print "INS", "15000-19999",$NF}' >> classes.txt
bcftools view -i 'SVTYPE=="INS" & SVLEN>=20000 & SVLEN<25000' ACCESS_FLT/FILTERS_18_1000/QUAL20/MAXDIST1000/Merged_minQ20_maxDist1000.vcf.gz | bcftools stats | grep "number of records:" | awk '{print "INS", "20000-24999",$NF}' >> classes.txt
bcftools view -i 'SVTYPE=="INS" & SVLEN>=25000 & SVLEN<30000' ACCESS_FLT/FILTERS_18_1000/QUAL20/MAXDIST1000/Merged_minQ20_maxDist1000.vcf.gz | bcftools stats | grep "number of records:" | awk '{print "INS", "25000-29999",$NF}' >> classes.txt
bcftools view -i 'SVTYPE=="INS" & SVLEN>=30000 & SVLEN<35000' ACCESS_FLT/FILTERS_18_1000/QUAL20/MAXDIST1000/Merged_minQ20_maxDist1000.vcf.gz | bcftools stats | grep "number of records:" | awk '{print "INS", "30000-34999",$NF}' >> classes.txt
bcftools view -i 'SVTYPE=="INS" & SVLEN>=35000 & SVLEN<40000' ACCESS_FLT/FILTERS_18_1000/QUAL20/MAXDIST1000/Merged_minQ20_maxDist1000.vcf.gz | bcftools stats | grep "number of records:" | awk '{print "INS", "35000-39999",$NF}' >> classes.txt
bcftools view -i 'SVTYPE=="INS" & SVLEN>=40000 & SVLEN<45000' ACCESS_FLT/FILTERS_18_1000/QUAL20/MAXDIST1000/Merged_minQ20_maxDist1000.vcf.gz | bcftools stats | grep "number of records:" | awk '{print "INS", "40000-44999",$NF}' >> classes.txt
bcftools view -i 'SVTYPE=="INS" & SVLEN>=45000 & SVLEN<50000' ACCESS_FLT/FILTERS_18_1000/QUAL20/MAXDIST1000/Merged_minQ20_maxDist1000.vcf.gz | bcftools stats | grep "number of records:" | awk '{print "INS", "45000-49999",$NF}' >> classes.txt
bcftools view -i 'SVTYPE=="INS" & SVLEN>=50000' ACCESS_FLT/FILTERS_18_1000/QUAL20/MAXDIST1000/Merged_minQ20_maxDist1000.vcf.gz | bcftools stats | grep "number of records:" | awk '{print "INS", ">=50000",$NF}' >> classes.txt

# Characterise del
bcftools view -i 'SVTYPE=="DEL" & SVLEN<=-5000 & SVLEN>-10000' ACCESS_FLT/FILTERS_18_1000/QUAL20/MAXDIST1000/Merged_minQ20_maxDist1000.vcf.gz | bcftools stats | grep "number of records:" | awk '{print "DEL", "5000-4999",$NF}' >> classes.txt
bcftools view -i 'SVTYPE=="DEL" & SVLEN<=-10000 & SVLEN>-15000' ACCESS_FLT/FILTERS_18_1000/QUAL20/MAXDIST1000/Merged_minQ20_maxDist1000.vcf.gz | bcftools stats | grep "number of records:" | awk '{print "DEL", "10000-14999",$NF}' >> classes.txt
bcftools view -i 'SVTYPE=="DEL" & SVLEN<=-15000 & SVLEN>-20000' ACCESS_FLT/FILTERS_18_1000/QUAL20/MAXDIST1000/Merged_minQ20_maxDist1000.vcf.gz | bcftools stats | grep "number of records:" | awk '{print "DEL", "15000-19999",$NF}' >> classes.txt
bcftools view -i 'SVTYPE=="DEL" & SVLEN<=-20000 & SVLEN>-25000' ACCESS_FLT/FILTERS_18_1000/QUAL20/MAXDIST1000/Merged_minQ20_maxDist1000.vcf.gz | bcftools stats | grep "number of records:" | awk '{print "DEL", "20000-24999",$NF}' >> classes.txt
bcftools view -i 'SVTYPE=="DEL" & SVLEN<=-25000 & SVLEN>-30000' ACCESS_FLT/FILTERS_18_1000/QUAL20/MAXDIST1000/Merged_minQ20_maxDist1000.vcf.gz | bcftools stats | grep "number of records:" | awk '{print "DEL", "25000-29999",$NF}' >> classes.txt
bcftools view -i 'SVTYPE=="DEL" & SVLEN<=-30000 & SVLEN>-35000' ACCESS_FLT/FILTERS_18_1000/QUAL20/MAXDIST1000/Merged_minQ20_maxDist1000.vcf.gz | bcftools stats | grep "number of records:" | awk '{print "DEL", "30000-34999",$NF}' >> classes.txt
bcftools view -i 'SVTYPE=="DEL" & SVLEN<=-35000 & SVLEN>-40000' ACCESS_FLT/FILTERS_18_1000/QUAL20/MAXDIST1000/Merged_minQ20_maxDist1000.vcf.gz | bcftools stats | grep "number of records:" | awk '{print "DEL", "35000-39999",$NF}' >> classes.txt
bcftools view -i 'SVTYPE=="DEL" & SVLEN<=-40000 & SVLEN>-45000' ACCESS_FLT/FILTERS_18_1000/QUAL20/MAXDIST1000/Merged_minQ20_maxDist1000.vcf.gz | bcftools stats | grep "number of records:" | awk '{print "DEL", "40000-44999",$NF}' >> classes.txt
bcftools view -i 'SVTYPE=="DEL" & SVLEN<=-45000 & SVLEN>-50000' ACCESS_FLT/FILTERS_18_1000/QUAL20/MAXDIST1000/Merged_minQ20_maxDist1000.vcf.gz | bcftools stats | grep "number of records:" | awk '{print "DEL", "45000-49999",$NF}' >> classes.txt
bcftools view -i 'SVTYPE=="DEL" & SVLEN<=-50000' ACCESS_FLT/FILTERS_18_1000/QUAL20/MAXDIST1000/Merged_minQ20_maxDist1000.vcf.gz | bcftools stats | grep "number of records:" | awk '{print "DEL", ">=50000",$NF}' >> classes.txt

