#!/bin/bash
##SBATCH --mail-type=ALL                    #Mail events (NONE, BEGIN, END, FAIL, ALL)
##SBATCH --mail-user=           # Where to send mail - change <username> to your  userid
#SBATCH -p compute-64-512                          #Which queue to use
#SBATCH -t 36:00:00                               # Set time limit to 36 hours
#SBATCH --job-name=het        #Job name
#SBATCH --mem 16G
#SBATCH -o het.out                    #Standard output log
#SBATCH -e het.err                     #Standard error log

# ==============================================================================
# SECTION 1: SYSTEM ENVIRONMENT & HPC MODULE LOADING
# ==============================================================================

# Load vcftools into the shell environment from the cluster's module repository
module load vcftools

# ==============================================================================
# SECTION 2: GENOMIC DATA PROCESSING & HETEROZYGOSITY ESTIMATION
# ==============================================================================

# Execute VCFtools to compute individual-level heterozygosity metrics
vcftools \
  # Source File: Provide the absolute filepath to the compressed, bgzipped variant call dataset
  --gzvcf /gpfs/home/qxf20ddu/Tribolium_files/T_cas_vcf/bcftools_Tribolium_castaneum.Tcas5.2.dna_sm.toplevel__genetic_rescue__20230926.SNPs.vcf.gz \
  \
  # Analysis Flag: Calculates inbreeding coefficients (F) and observed vs. expected homozygous sites
  --het \
  \
  # Output Path: Defines the file prefix where the text results (.het) will be saved
  --out bcftools_Tribolium_castaneum.Tcas5.2.dna_sm.toplevel__genetic_rescue__20230926.SNPs_vcftools.het
