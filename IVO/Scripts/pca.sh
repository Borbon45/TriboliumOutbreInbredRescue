#!/bin/bash
##SBATCH --mail-type=ALL                    #Mail events (NONE, BEGIN, END, FAIL, ALL)
##SBATCH --mail-user=           # Where to send mail - change <username> to your  userid
#SBATCH -p compute-64-512                          #Which queue to use
#SBATCH -t 36:00:00                               # Set time limit to 36 hours
#SBATCH --job-name=gr_snps_plink_ldpruned_50100.1_plink_pca        #Job name
#SBATCH --mem 16G
#SBATCH -o gr_snps_plink_ldpruned_50100.1_plink_pca.out                    #Standard output log
#SBATCH -e gr_snps_plink_ldpruned_50100.1_plink_pca.err                     #Standard error log

# ==============================================================================
# SECTION 1: SYSTEM ENVIRONMENT & HPC MODULE LOADING
# ==============================================================================

# Load PLINK (v1.90) into the shell environment from the cluster repository
module add plink/1.90

# ==============================================================================
# SECTION 2: LINKAGE DISEQUILIBRIUM (LD) PRUNING
# ==============================================================================

# Perform pairwise linkage pruning to identify independent, non-redundant SNPs
plink \
  # Input Source: Path to the raw compressed bgzipped VCF file
  --vcf /gpfs/home/qxf20ddu/Tribolium_files/T_cas_vcf/bcftools_Tribolium_castaneum.Tcas5.2.dna_sm.toplevel__genetic_rescue__20230926.SNPs.vcf.gz \
  \
  # Structural Tweaks: Forces both family and individual IDs to match the VCF sample header
  --double-id \
  \
  # Scaffold Support: Prevents PLINK from crashing on non-standard/unplaced scaffold names
  --allow-extra-chr \
  \
  # Variant Labeling: Assigns clear IDs to missing variants using the format 'Chrom:Position'
  --set-missing-var-ids @:# \
  \
  # Pruning Metrics: Window size = 50 SNPs, Step size = 10 SNPs, r^2 threshold = 0.1
  --indep-pairwise 50 10 0.1 \
  \
  # Output Prefix: Generates 'gr_tcas.prune.in' (kept) and 'gr_tcas.prune.out' (removed)
  --out gr_tcas

# ==============================================================================
# SECTION 3: VARIANT EXTRACTION & EIGEN-DECOMPOSITION (PCA)
# ==============================================================================

# Extract the unlinked variants, convert data to binary format, and run the PCA
plink \
  # Input Source: Re-read the primary compressed VCF file
  --vcf /gpfs/home/qxf20ddu/Tribolium_files/T_cas_vcf/bcftools_Tribolium_castaneum.Tcas5.2.dna_sm.toplevel__genetic_rescue__20230926.SNPs.vcf.gz \
  --double-id \
  --allow-extra-chr \
  --set-missing-var-ids @:# \
  \
  # Filtering: Subset data to keep ONLY the independent markers listed in the prune file
  --extract gr_tcas.prune.in \
  \
  # File Generation: Compiles a binary PLINK dataset (.bed, .bim, .fam) for fast future loading
  --make-bed \
  \
  # Analysis Flag: Calculates the variance-standardized genomic relationship matrix
  --pca \
  \
  # Output Prefix: Generates 'gr_tcas.eigenvec' and 'gr_tcas.eigenval' for R visualization
  --out gr_tcas
--make-bed --pca --out gr_tcas
