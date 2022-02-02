#!/bin/bash

## Assess by filtering all SV sizes
## ranging between 500 and 5000bp, in 500bp intervals

vcflist=$1
nthreads=$2

parallel -j $nthreads BionanoAssessFilters_local.sh $vcflist {} ::: $(seq 500 500 5000)
