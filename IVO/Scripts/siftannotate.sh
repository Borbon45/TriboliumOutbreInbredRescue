#!/bin/bash
#SBATCH -N 1
#SBATCH -o /gpfs/home/qxf20ddu/SIFT4G_tests/SIFT4G_Create_Genomic_DB/2_test/SA.otxt
#SBATCH -e /gpfs/home/qxf20ddu/SIFT4G_tests/SIFT4G_Create_Genomic_DB/2_test/SA.sh.etxt
#SBATCH -p "compute-64-512"
#SBATCH -J SA
#SBATCH -t 48:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --mem=80000
#SBATCH -c 8

# ==============================================================================
# SECTION 1: SYSTEM ENVIRONMENT & RUNTIME INVOCATION
# ==============================================================================

# Invoke the Java Virtual Machine (JVM) runtime environment to execute SIFT4G
java -jar SIFT4G_Annotator.jar \
  \
  # Input Conversion: Converts the variant coordinates to a SIFT-compatible format
  -c \
  \
  # Target Dataset: Absolute or relative filepath to the raw uncompressed input VCF 
  -i bcftools_Tribolium_castaneum.Tcas5.2.dna_sm.toplevel__genetic_rescue__20230926.SNPs.vcf \
  \
  # Reference Library: Path to the pre-compiled organism-specific SIFT database directory
  -d Tcas5.2/ \
  \
  # Output Destination: Defines the custom filename prefix for the generated results
  -r vcfsift \
  \
  # Multithreading: Enables task parallelization to utilize multiple available CPU cores
  -t
