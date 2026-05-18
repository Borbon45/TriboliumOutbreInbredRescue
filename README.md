# TriboliumOutbreInbredRescue
Data and Scripts for Experimental evidence that outbred rescuers enhance sustained genetic rescue outcomes despite introducing novel deleterious variation.
This repository contains the data and custom scripts required to replicate the analysis and figures presented in the manuscript.

## 📁 Repository Structure
IVO/
├── Data/
│   ├── IvO.csv                       # CSV file containing productivity values from experiment
│   ├── bcftools_Tribolium_castaneum...# VCF/BCF processing output for T. castaneum
│   ├── gr_tcas.eigenval              # Eigenvalues from PCA analysis
│   ├── gr_tcas.eigenvec              # Eigenvectors from PCA analysis
│   ├── psc_output_confident.txt      # [Describe output data/metrics]
│   └── psc_snps_stats.txt            # SNP statistics summary file
├── Scripts/
│   ├── Fig 1B.R                      # R script to generate Figure 1B
│   ├── Fig 2.R                       # R script to generate Figure 2
│   ├── Fig 3.R                       # R script to generate Figure 3
│   ├── Fig S1.R                      # R script to generate Supplemental Figure S1
│   ├── Table1.R                      # R script to calculate values for Table 1
│   ├── het.sh                        # Bash script for heterozygosity analysis
│   ├── pca.sh                        # Bash script running Principal Component Analysis
│   ├── siftannotate.sh               # Bash script running SIFT annotations
│   └── tcas_gdb.sh                   # Bash script for creating SIFT database
└── README.md                         # This file
