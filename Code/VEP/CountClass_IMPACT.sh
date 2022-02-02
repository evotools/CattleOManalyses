#!/bin/bash

if [ -e classes_impact.txt ]; then rm classes_impact.txt; fi
infile=$1

for i in HIGH MODERATE LOW; do
# Characterise ins
bcftools view -i 'SVTYPE=="INS" & SVLEN>=5000 & SVLEN<10000' $infile | bcftools view -i "CSQ~'$i'" | bcftools stats | grep "number of records:" | awk -v impact=$i '{print impact, "INS", "5000-4999",$NF}' 
bcftools view -i 'SVTYPE=="INS" & SVLEN>=10000 & SVLEN<15000' $infile | bcftools view -i "CSQ~'$i'" | bcftools stats | grep "number of records:" | awk -v impact=$i '{print impact,"INS", "10000-14999",$NF}' 
bcftools view -i 'SVTYPE=="INS" & SVLEN>=15000 & SVLEN<20000' $infile | bcftools view -i "CSQ~'$i'" | bcftools stats | grep "number of records:" | awk -v impact=$i '{print impact,"INS", "15000-19999",$NF}' 
bcftools view -i 'SVTYPE=="INS" & SVLEN>=20000 & SVLEN<25000' $infile | bcftools view -i "CSQ~'$i'" | bcftools stats | grep "number of records:" | awk -v impact=$i '{print impact,"INS", "20000-24999",$NF}' 
bcftools view -i 'SVTYPE=="INS" & SVLEN>=25000 & SVLEN<30000' $infile | bcftools view -i "CSQ~'$i'" | bcftools stats | grep "number of records:" | awk -v impact=$i '{print impact,"INS", "25000-29999",$NF}' 
bcftools view -i 'SVTYPE=="INS" & SVLEN>=30000 & SVLEN<35000' $infile | bcftools view -i "CSQ~'$i'" | bcftools stats | grep "number of records:" | awk -v impact=$i '{print impact,"INS", "30000-34999",$NF}' 
bcftools view -i 'SVTYPE=="INS" & SVLEN>=35000 & SVLEN<40000' $infile | bcftools view -i "CSQ~'$i'" | bcftools stats | grep "number of records:" | awk -v impact=$i '{print impact,"INS", "35000-39999",$NF}' 
bcftools view -i 'SVTYPE=="INS" & SVLEN>=40000 & SVLEN<45000' $infile | bcftools view -i "CSQ~'$i'" | bcftools stats | grep "number of records:" | awk -v impact=$i '{print impact,"INS", "40000-44999",$NF}' 
bcftools view -i 'SVTYPE=="INS" & SVLEN>=45000 & SVLEN<50000' $infile | bcftools view -i "CSQ~'$i'" | bcftools stats | grep "number of records:" | awk -v impact=$i '{print impact,"INS", "45000-49999",$NF}' 
bcftools view -i 'SVTYPE=="INS" & SVLEN>=50000' $infile | bcftools view -i "CSQ~'$i'" | bcftools stats | grep "number of records:" | awk -v impact=$i '{print impact,"INS", ">=50000",$NF}' 

# Characterise del
bcftools view -i 'SVTYPE=="DEL" & SVLEN<=-5000 & SVLEN>-10000' $infile | bcftools view -i "CSQ~'$i'" | bcftools stats | grep "number of records:" | awk -v impact=$i '{print impact,"DEL", "5000-4999",$NF}' 
bcftools view -i 'SVTYPE=="DEL" & SVLEN<=-10000 & SVLEN>-15000' $infile | bcftools view -i "CSQ~'$i'" | bcftools stats | grep "number of records:" | awk -v impact=$i '{print impact,"DEL", "10000-14999",$NF}' 
bcftools view -i 'SVTYPE=="DEL" & SVLEN<=-15000 & SVLEN>-20000' $infile | bcftools view -i "CSQ~'$i'" | bcftools stats | grep "number of records:" | awk -v impact=$i '{print impact,"DEL", "15000-19999",$NF}' 
bcftools view -i 'SVTYPE=="DEL" & SVLEN<=-20000 & SVLEN>-25000' $infile | bcftools view -i "CSQ~'$i'" | bcftools stats | grep "number of records:" | awk -v impact=$i '{print impact,"DEL", "20000-24999",$NF}' 
bcftools view -i 'SVTYPE=="DEL" & SVLEN<=-25000 & SVLEN>-30000' $infile | bcftools view -i "CSQ~'$i'" | bcftools stats | grep "number of records:" | awk -v impact=$i '{print impact,"DEL", "25000-29999",$NF}' 
bcftools view -i 'SVTYPE=="DEL" & SVLEN<=-30000 & SVLEN>-35000' $infile | bcftools view -i "CSQ~'$i'" | bcftools stats | grep "number of records:" | awk -v impact=$i '{print impact,"DEL", "30000-34999",$NF}' 
bcftools view -i 'SVTYPE=="DEL" & SVLEN<=-35000 & SVLEN>-40000' $infile | bcftools view -i "CSQ~'$i'" | bcftools stats | grep "number of records:" | awk -v impact=$i '{print impact,"DEL", "35000-39999",$NF}' 
bcftools view -i 'SVTYPE=="DEL" & SVLEN<=-40000 & SVLEN>-45000' $infile | bcftools view -i "CSQ~'$i'" | bcftools stats | grep "number of records:" | awk -v impact=$i '{print impact,"DEL", "40000-44999",$NF}' 
bcftools view -i 'SVTYPE=="DEL" & SVLEN<=-45000 & SVLEN>-50000' $infile | bcftools view -i "CSQ~'$i'" | bcftools stats | grep "number of records:" | awk -v impact=$i '{print impact,"DEL", "45000-49999",$NF}' 
bcftools view -i 'SVTYPE=="DEL" & SVLEN<=-50000' $infile | bcftools view -i "CSQ~'$i'" | bcftools stats | grep "number of records:" | awk -v impact=$i '{print impact,"DEL", ">=50000",$NF}'

done > classes_impact.txt
