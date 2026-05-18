#!/bin/bash
#SBATCH -N 1
#SBATCH -o /gpfs/home/qxf20ddu/SIFT4G_tests/SIFT4G_Create_Genomic_DB/2_test/Tcas.sh.otxt
#SBATCH -e /gpfs/home/qxf20ddu/SIFT4G_tests/SIFT4G_Create_Genomic_DB/2_test/Tcas.sh.etxt
#SBATCH -p "compute-64-512"
#SBATCH -J Tcas
#SBATCH -t 48:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --mem=80000
#SBATCH -c 8

# ==============================================================================
# SECTION 1: SYSTEM ENVIRONMENT & HPC MODULE LOADING
# ==============================================================================

# Load SIFT4G framework (v2.0.0) into the shell environment from the cluster
module add SIFT4G/2.0.0

# ==============================================================================
# SECTION 2: CUSTOM REFERENCE DATABASE COMPILATION
# ==============================================================================

# Execute the core Perl automation wrapper to compile the genomic SIFT database
make-SIFT-db-all.pl \
  # Configuration Profile: Path to the structural text file mapping the genome's paths
  -config /gpfs/home/qxf20ddu/SIFT4G_tests/SIFT4G_Create_Genomic_DB/2_test/tribolium_castaneum_config.txt
