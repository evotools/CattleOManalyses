# Cattle Optical Map analyses
Script and VEP results from the Optical mapping SV analyses from Talenti et al.

## Content
The following repository contains two subfolders
 1. [Results](https://github.com/evotools/CattleOManalyses/tree/main/Results): this folder contains the results from some analyses (e.g. the VEP HTML report [here](https://htmlpreview.github.io/https://github.com/evotools/CattleOManalyses/blob/main/Results/VEP/stats_summary.html))
 2. [Code](https://github.com/evotools/CattleOManalyses/tree/main/Code): the code used to run the analyses described in the paper

## Code
To successfully run the scripts here presented you will need the following dependencies:
- [R](https://www.r-project.org/) with the following packages:
  - tidyverse
  - ggfortify
  - hrbrthemes
  - ggsci
  - ggpubr
  - ComplexHeatmap
  - gridExtra
  - cowplot
  - RColorBrewer
- [python](https://www.python.org/)
- [SURVIVOR](https://github.com/fritzsedlazeck/SURVIVOR/)
- [bedtools](https://bedtools.readthedocs.io/en/latest/)
- [bcftools](https://samtools.github.io/bcftools/bcftools.html)
- [docker](https://samtools.github.io/bcftools/bcftools.html)

You will also need the 

The `Code` folder contains the following subfolders:
 1. `RunBionanoSolve`: an example of the code used to process the optical mapping using the Bionano Solve workflow
 2. `VEP`: the code used to run the VEP
 3. `CountClasses`: the code used to generate the histogram in Figure 1 and to extract the numbers represented
 4. `AssessFiltering`: the code to assess multiple filtering thresholds, following the Bionano access prefiltering, and generation of the UpSet plot
 5. `SizeAndSupportAnalysis`: the code used to assess the SV size based on the support (i.e. number of individuals that present the SVs) of the variant
 6. `nonRedundantDeletions`: the code used to extract the filtered Deletions into bed format to compute the non-redundant reference sequence in deletions 
 7. `GeneAnalysis`: the code used to extract the coding sequences and gene features that have an overlap with an identified SV
